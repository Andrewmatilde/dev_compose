/**
 * @id py/examples/call
 * @name Calls to function
 * @description Finds calls to any function named "len"
 * @tags call
 *       function
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import semmle.python.Flow

predicate isFile0(File f) {
    f.getAbsolutePath().indexOf("/root/compute-engine/jobs/infra_report/") = 0
}

predicate isFile1(File f) {
    f.getAbsolutePath().indexOf("/root/compute-engine/jobs/infra_report/schema.py") = 0
}

class ToVar extends TaintTracking::Configuration {
    ToVar() { this = "ToVar" }
    
    override predicate isSource(DataFlow::Node node) {
        isFile1(node.getLocation().getFile()) and
        node.getLocation().getStartLine() = 22
    }
    
    override predicate isSink(DataFlow::Node node) {
        isFile0(node.getLocation().getFile())
    }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        isFile0(pred.getLocation().getFile()) and
        isFile0(succ.getLocation().getFile()) and
        (
            (
                succ.asCfgNode() instanceof AttrNode and
                exists(AttrNode attr | succ.asCfgNode().(AttrNode) = attr and pred.asCfgNode() = attr.getAPredecessor())
                ) or
            (
                succ instanceof DataFlow::CallCfgNode and
                succ.asCfgNode().(CallNode).getAnArg() = pred.asCfgNode()
            )
        )
    }
}

from DataFlow::Node source, DataFlow::Node sink, ToVar cfg
where cfg.hasFlow(source, sink) and
source instanceof DataFlow::EssaNode
select source, sink, sink.getLocation()