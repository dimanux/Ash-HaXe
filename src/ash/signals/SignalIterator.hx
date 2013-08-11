package ash.signals;

#if cpp
import cpp.FastIterator;
#end

class SignalIterator<TListener> #if cpp extends FastIterator<ListenerNode<TListener>> #end
{
    private var previous:ListenerNode<TListener>;
	private var pooled:Bool = false;
	private var nextPooled:SignalIterator<TListener> = null;
	private static var pool : Dynamic = null;

    public function new(head:ListenerNode<TListener>)
    {
		this.previous = head;
    }

    #if cpp override #end public function hasNext():Bool
    {
		if (pooled && (previous == null))
		{
			nextPooled = pool;
			pool = this;
			return false;
		}
		return previous != null;
    }

    #if cpp override #end public function next():ListenerNode<TListener>
    {
        var node:ListenerNode<TListener> = previous;
        previous = node.next;
        return node;
    }
	
	public static function getFromPool<TListener>(head:ListenerNode<TListener>) : SignalIterator<TListener>
	{
		if (pool == null)
		{
			var it : SignalIterator<TListener> = new SignalIterator<TListener>(head);
			it.pooled = true;
			return it;
		}
		else
		{
			var it : SignalIterator<TListener> = pool;
			pool = it.nextPooled;
			it.previous = head;
			it.nextPooled = null;
			return it;
		}
	}
}