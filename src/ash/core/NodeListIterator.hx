package ash.core;

class NodeListIterator<TNode:Node<TNode>>
{
    private var previous:TNode;
	private var pooled:Bool = false;
	private var nextPooled:NodeListIterator<TNode> = null;
	private static var pool : Dynamic = null;

    public function new(head:TNode)
    {
		this.previous = head;
    }

    public function hasNext():Bool
    {
		if (pooled && (previous == null))
		{
			nextPooled = pool;
			pool = this;
			return false;
		}
		return previous != null;
    }

    public function next():TNode
    {
        var node:TNode = previous;
        previous = node.next;
        return node;
    }
	
	public static function getFromPool<TNode:Node<TNode>>(head:TNode) : NodeListIterator<TNode>
	{
		if (pool == null)
		{
			var it : NodeListIterator<TNode> = new NodeListIterator<TNode>(head);
			it.pooled = true;
			return it;
		}
		else
		{
			var it : NodeListIterator<TNode> = pool;
			pool = it.nextPooled;
			it.previous = head;
			it.nextPooled = null;
			return it;
		}
	}
}