package ash;

/**
 * An iterator class for any linked lists that
 * has "next" variable in its elements.
 **/
class GenericListIterator<TNode:HasNext<TNode>>
{
	private var base:HasNext<TNode>;
	private var previous:HasNext<TNode>;
	private var fromPool:Bool = false;

    public function new(head:TNode)
    {
        this.base = this.previous = {next: head};
    }

    public function hasNext():Bool
    {
		if (previous.next == null && fromPool)
			pool.push(this);
        return previous.next != null;
    }

    public function next():TNode
    {
        var node:TNode = previous.next;
        previous = node;
		base.next = null;
        return node;
    }
	
	private static var pool:Array<Dynamic> = [];
	
	public static function get<TNode:HasNext<TNode>>(head:TNode) : GenericListIterator<TNode>
	{
		if (pool.length > 0)
		{
			var iterator = pool.pop();
			iterator.base.next = head;
			iterator.previous = iterator.base;
			return iterator;
		}
		else
		{
			var iterator = new GenericListIterator(head);
			iterator.fromPool = true;
			return iterator;
		}
	}
}

private typedef HasNext<T> =
{
    var next:T;
}
