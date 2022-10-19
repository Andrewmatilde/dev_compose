/**
 * @id py/examples/call
 * @name func to function
 * @description Finds calls to any function named "len"
 * @tags call
 *       function
 */

import python

predicate isRootFile(File f) {
    f.getAbsolutePath().indexOf("/root/") = 0
}



from Function func
where isRootFile(func.getLocation().getFile())
select func.getLocation()