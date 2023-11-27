#' Multivariate Imputation by Chained Equations within Groups
#' 
#' \code{mice_by_group} takes a data frame with a grouping column and columns
#' to be used in the MICE imputation and returns a list of data frames with 
#' multiply imputed data. 
#' 
#' @param Data A data frame containing all variables (columns) to be used in 
#' the MICE equations and a column with the grouping variable.
#' @param groupvar The column name in \code{Data} for the grouping variable. If
#' this column is not of the class 'factor', it will be converted to a factor
#' with the default order of factor levels.
#' @param miceArgs These are arguments to be passed on to the \code{mice}
#' function from the 'mice' package. These include the number of imputed data 
#' frames to be generated \code{m} (default = 10), the maximum number of MICE 
#' iterations \code{maxit} (default = 10), a random seed to be set for the MICE
#' for reproducibility \code{seed} (default = 123), and a Boolean option for 
#' verbose printing \code{printFlag} (default = FALSE). All other \code{mice} 
#' function arguments default to the same values as in the 'mice' package (see 
#' \code{?mice::mice} for details). Note that the default \code{m} and 
#' \code{maxit} for \code{mice} are both 5, though I set them to 10 for this
#' function for more iterations and better convergence, respectively.  
#' 
#' @return \code{mice_by_group} returns a list of imputed data frames.
#' 
#' @import mice
#' @import purrr
#' @export mice_by_group
#' 
#' @examples 
#' library(mice)
#' 
#' nhanes$Group <- as.factor(rep(LETTERS[1:2], times = c(12, 13)))
#' implist <-  mice_by_group(nhanes, "Group", list(m=5,maxit=5,seed=2))
#' 
mice_by_group <- function(Data, groupvar, miceArgs = list(
  m = 10, maxit = 10, seed = 123, printFlag = FALSE)){
  
  if(!is.factor(Data[, groupvar])) Data[, groupvar] <- as.factor(Data[, groupvar])
  if(is.null(rownames(Data))) rownames(Data) <- 1:nrow(Data)
  
  groupsumm <- summary(Data[, groupvar])
  
  getgroupmice <- function(str){
    tmpdat <- Data[which(Data[, groupvar] == str), -which(names(Data) == groupvar)]
    tmpdat[, sapply(tmpdat,is.factor)] <- lapply(tmpdat[
      , sapply(tmpdat, is.factor)], droplevels)
    do.call(mice, c(list(data=tmpdat), miceArgs))
  }
  
  micelist <- lapply(levels(Data[, groupvar]), getgroupmice)
  impdatlist <- lapply(micelist, function(x) map(1:x$m,
                                                 function(j) complete(x,j)))
  rb_nthitem <- function(x,i) do.call(rbind, lapply(x,`[[`,i))
  dflist <- lapply(1:micelist[[1]]$m, rb_nthitem, x=impdatlist)
  rownlist <- lapply(micelist, function(x) rownames(x$where))
  
  addgroupvar <- function(x){
    rownames(x) <- do.call("c",rownlist)
    x[,groupvar] <- factor(rep(levels(Data[, groupvar]), groupsumm),
                           levels = levels(Data[, groupvar]))
    x <- x[rownames(Data), names(Data)]
    x
  }
  
  dflist <- lapply(dflist, addgroupvar)
  return(dflist)
}