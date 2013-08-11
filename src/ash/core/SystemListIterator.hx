package ash.core;

#if cpp
import cpp.FastIterator;
#end

class SystemListIterator #if cpp extends FastIterator<System> #end
{
    private var previous:System;
	private var pooled:Bool = false;
	private var nextPooled:SystemListIterator = null;
	private static var pool : Dynamic = null;

    public function new(head:System)
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

    #if cpp override #end public function next():System
    {
        var system:System = previous;
        previous = system.next;
        return system;
    }
	
	public static function getFromPool(head:System) : SystemListIterator
	{
		if (pool == null)
		{
			var it : SystemListIterator = new SystemListIterator(head);
			it.pooled = true;
			return it;
		}
		else
		{
			var it : SystemListIterator = pool;
			pool = it.nextPooled;
			it.previous = head;
			it.nextPooled = null;
			return it;
		}
	}
}