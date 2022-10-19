/**
 * @id py/examples/call
 * @name Calls to function
 * @description Finds calls to any function named "len"
 * @tags call
 *       function
 */

import python


predicate isRootFile(File f) {
    f.getAbsolutePath().indexOf("/root/") = 0
}

predicate isAttribute(Call call) {
    call.getFunc() instanceof Attribute 
}


from Call call
where isRootFile(call.getLocation().getFile())
and isAttribute(call)
select call.getFunc().getASubExpression().getLocation(), call.getFunc().getASubExpression(), call.getFunc().(Attribute).getName()