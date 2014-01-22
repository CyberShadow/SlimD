/**
 * Contains all implicitly declared types and variables.
 *
 * Copyright: Copyright Digital Mars 2000 - 2011.
 * License:   <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
 * Authors:   Walter Bright, Sean Kelly
 *
 *          Copyright Digital Mars 2000 - 2011.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module object;

private
{
    import slim.stdc.string;
    import slim.rt.util.hash;
    import slim.rt.util.string;
    extern (C) Object _d_newclass(TypeInfo_Class ci);
}

alias typeof(int.sizeof)                    size_t;
alias typeof(cast(void*)0 - cast(void*)0)   ptrdiff_t;
alias ptrdiff_t                             sizediff_t;

alias size_t hash_t;
alias bool equals_t;

alias immutable(char)[]  string;
alias immutable(wchar)[] wstring;
alias immutable(dchar)[] dstring;

/**
 * All D class objects inherit from Object.
 */
class Object
{
    /**
     * Convert Object to a human readable string.
     */
    string toString()
    {
        return this.classinfo.name;
    }

    /**
     * Compute hash function for Object.
     */
    hash_t toHash()
    {
        // BUG: this prevents a compacting GC from working, needs to be fixed
        return cast(hash_t)cast(void*)this;
    }

    /**
     * Compare with another Object obj.
     * Returns:
     *  $(TABLE
     *  $(TR $(TD this &lt; obj) $(TD &lt; 0))
     *  $(TR $(TD this == obj) $(TD 0))
     *  $(TR $(TD this &gt; obj) $(TD &gt; 0))
     *  )
     */
    int opCmp(Object o)
    {
        // BUG: this prevents a compacting GC from working, needs to be fixed
        //return cast(int)cast(void*)this - cast(int)cast(void*)o;

        throw new Exception("need opCmp for class " ~ this.classinfo.name);
        //return this !is o;
    }

    /**
     * Returns !=0 if this object does have the same contents as obj.
     */
    equals_t opEquals(Object o)
    {
        return this is o;
    }

    equals_t opEquals(Object lhs, Object rhs)
    {
        if (lhs is rhs)
            return true;
        if (lhs is null || rhs is null)
            return false;
	// SLIMD-TODO
        //if (typeid(lhs) == typeid(rhs))
        //    return lhs.opEquals(rhs);
        return lhs.opEquals(rhs) &&
               rhs.opEquals(lhs);
    }

    interface Monitor
    {
        void lock();
        void unlock();
    }

    /**
     * Create instance of class specified by classname.
     * The class must either have no constructors or have
     * a default constructor.
     * Returns:
     *   null if failed
     */
    static Object factory(string classname)
    {
        auto ci = TypeInfo_Class.find(classname);
        if (ci)
        {
            return ci.create();
        }
        return null;
    }
}

/************************
 * Returns true if lhs and rhs are equal.
 */
bool opEquals(Object lhs, Object rhs)
{
    // If aliased to the same object or both null => equal
    if (lhs is rhs) return true;

    // If either is null => non-equal
    if (lhs is null || rhs is null) return false;

    // If same exact type => one call to method opEquals
    if (typeid(lhs) is typeid(rhs) || typeid(lhs).opEquals(typeid(rhs)))
        return lhs.opEquals(rhs);

    // General case => symmetric calls to method opEquals
    return lhs.opEquals(rhs) && rhs.opEquals(lhs);
}

bool opEquals(TypeInfo lhs, TypeInfo rhs)
{
    // If aliased to the same object or both null => equal
    if (lhs is rhs) return true;

    // If either is null => non-equal
    if (lhs is null || rhs is null) return false;

    // If same exact type => one call to method opEquals
    if (typeid(lhs) == typeid(rhs)) return lhs.opEquals(rhs);

    //printf("%.*s and %.*s, %d %d\n", lhs.toString(), rhs.toString(), lhs.opEquals(rhs), rhs.opEquals(lhs));

    // Factor out top level const
    // (This still isn't right, should follow same rules as compiler does for type equality.)
    TypeInfo_Const c = cast(TypeInfo_Const) lhs;
    if (c)
        lhs = c.base;
    c = cast(TypeInfo_Const) rhs;
    if (c)
        rhs = c.base;

    // General case => symmetric calls to method opEquals
    return lhs.opEquals(rhs) && rhs.opEquals(lhs);
}

/**
 * Information about an interface.
 * When an object is accessed via an interface, an Interface* appears as the
 * first entry in its vtbl.
 */
struct Interface
{
    TypeInfo_Class   classinfo;  /// .classinfo for this interface (not for containing class)
    void*[]     vtbl;
    ptrdiff_t   offset;     /// offset to Interface 'this' from Object 'this'
}

/**
 * Runtime type information about a class. Can be retrieved for any class type
 * or instance by using the .classinfo property.
 * A pointer to this appears as the first entry in the class's vtbl[].
 */
alias TypeInfo_Class Classinfo;

/**
 * Array of pairs giving the offset and type information for each
 * member in an aggregate.
 */
struct OffsetTypeInfo
{
    size_t   offset;    /// Offset of member from start of object
    TypeInfo ti;        /// TypeInfo for this member
}

/**
 * Runtime type information about a type.
 * Can be retrieved for any type using a
 * <a href="../expression.html#typeidexpression">TypeidExpression</a>.
 */
class TypeInfo
{
    override hash_t toHash()
    {
        auto data = this.toString();
        return hashOf(data.ptr, data.length);
    }

    override int opCmp(Object o)
    {
        if (this is o)
            return 0;
        TypeInfo ti = cast(TypeInfo)o;
        if (ti is null)
            return 1;
        return dstrcmp(this.toString(), ti.toString());
    }

    override equals_t opEquals(Object o)
    {
        /* TypeInfo instances are singletons, but duplicates can exist
         * across DLL's. Therefore, comparing for a name match is
         * sufficient.
         */
        if (this is o)
            return true;
        TypeInfo ti = cast(TypeInfo)o;
        return ti && this.toString() == ti.toString();
    }

    /// Returns a hash of the instance of a type.
    hash_t getHash(in void* p) { return cast(hash_t)p; }

    /// Compares two instances for equality.
    equals_t equals(in void* p1, in void* p2) { return p1 == p2; }

    /// Compares two instances for &lt;, ==, or &gt;.
    int compare(in void* p1, in void* p2) { return 0; }

    /// Returns size of the type.
    @property size_t tsize() nothrow pure { return 0; }

    /// Swaps two instances of the type.
    void swap(void* p1, void* p2)
    {
        size_t n = tsize;
        for (size_t i = 0; i < n; i++)
        {
            byte t = (cast(byte *)p1)[i];
            (cast(byte*)p1)[i] = (cast(byte*)p2)[i];
            (cast(byte*)p2)[i] = t;
        }
    }

    /// Get TypeInfo for 'next' type, as defined by what kind of type this is,
    /// null if none.
    @property TypeInfo next() nothrow pure { return null; }

    /// Return default initializer.  If the type should be initialized to all zeros,
    /// an array with a null ptr and a length equal to the type size will be returned.
    // TODO: make this a property, but may need to be renamed to diambiguate with T.init...
    void[] init() nothrow pure { return null; }

    /// Get flags for type: 1 means GC should scan for pointers
    @property uint flags() nothrow pure { return 0; }

    /// Get type information on the contents of the type; null if not available
    OffsetTypeInfo[] offTi() { return null; }
    /// Run the destructor on the object and all its sub-objects
    void destroy(void* p) {}
    /// Run the postblit on the object and all its sub-objects
    void postblit(void* p) {}


    /// Return alignment of type
    @property size_t talign() nothrow pure { return tsize; }

    /** Return internal info on arguments fitting into 8byte.
     * See X86-64 ABI 3.2.3
     */
    version (X86_64) int argTypes(out TypeInfo arg1, out TypeInfo arg2)
    {   arg1 = this;
        return 0;
    }
}

class TypeInfo_Typedef : TypeInfo
{
    override string toString() { return name; }

    override equals_t opEquals(Object o)
    {
        TypeInfo_Typedef c;
        return this is o ||
               ((c = cast(TypeInfo_Typedef)o) !is null &&
                this.name == c.name &&
                this.base == c.base);
    }

    override hash_t getHash(in void* p) { return base.getHash(p); }
    override equals_t equals(in void* p1, in void* p2) { return base.equals(p1, p2); }
    override int compare(in void* p1, in void* p2) { return base.compare(p1, p2); }
    @property override size_t tsize() nothrow pure { return base.tsize; }
    override void swap(void* p1, void* p2) { return base.swap(p1, p2); }

    @property override TypeInfo next() nothrow pure { return base.next; }
    @property override uint flags() nothrow pure { return base.flags; }
    override void[] init() nothrow pure { return m_init.length ? m_init : base.init(); }

    @property override size_t talign() nothrow pure { return base.talign; }

    version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
    {   return base.argTypes(arg1, arg2);
    }

    TypeInfo base;
    string   name;
    void[]   m_init;
}

class TypeInfo_Enum : TypeInfo_Typedef
{

}

class TypeInfo_Pointer : TypeInfo
{
    override string toString() { return m_next.toString() ~ "*"; }

    override equals_t opEquals(Object o)
    {
        TypeInfo_Pointer c;
        return this is o ||
                ((c = cast(TypeInfo_Pointer)o) !is null &&
                 this.m_next == c.m_next);
    }

    override hash_t getHash(in void* p)
    {
        return cast(hash_t)*cast(void**)p;
    }

    override equals_t equals(in void* p1, in void* p2)
    {
        return *cast(void**)p1 == *cast(void**)p2;
    }

    override int compare(in void* p1, in void* p2)
    {
        if (*cast(void**)p1 < *cast(void**)p2)
            return -1;
        else if (*cast(void**)p1 > *cast(void**)p2)
            return 1;
        else
            return 0;
    }

    @property override size_t tsize() nothrow pure
    {
        return (void*).sizeof;
    }

    override void swap(void* p1, void* p2)
    {
        void* tmp = *cast(void**)p1;
        *cast(void**)p1 = *cast(void**)p2;
        *cast(void**)p2 = tmp;
    }

    @property override TypeInfo next() nothrow pure { return m_next; }
    @property override uint flags() nothrow pure { return 1; }

    TypeInfo m_next;
}

class TypeInfo_Array : TypeInfo
{
    override string toString() { return value.toString() ~ "[]"; }

    override equals_t opEquals(Object o)
    {
        TypeInfo_Array c;
        return this is o ||
               ((c = cast(TypeInfo_Array)o) !is null &&
                this.value == c.value);
    }

    override hash_t getHash(in void* p)
    {
        void[] a = *cast(void[]*)p;
        return hashOf(a.ptr, a.length);
    }

    override equals_t equals(in void* p1, in void* p2)
    {
        void[] a1 = *cast(void[]*)p1;
        void[] a2 = *cast(void[]*)p2;
        if (a1.length != a2.length)
            return false;
        size_t sz = value.tsize;
        for (size_t i = 0; i < a1.length; i++)
        {
            if (!value.equals(a1.ptr + i * sz, a2.ptr + i * sz))
                return false;
        }
        return true;
    }

    override int compare(in void* p1, in void* p2)
    {
        void[] a1 = *cast(void[]*)p1;
        void[] a2 = *cast(void[]*)p2;
        size_t sz = value.tsize;
        size_t len = a1.length;

        if (a2.length < len)
            len = a2.length;
        for (size_t u = 0; u < len; u++)
        {
            int result = value.compare(a1.ptr + u * sz, a2.ptr + u * sz);
            if (result)
                return result;
        }
        return cast(int)a1.length - cast(int)a2.length;
    }

    @property override size_t tsize() nothrow pure
    {
        return (void[]).sizeof;
    }

    override void swap(void* p1, void* p2)
    {
        void[] tmp = *cast(void[]*)p1;
        *cast(void[]*)p1 = *cast(void[]*)p2;
        *cast(void[]*)p2 = tmp;
    }

    TypeInfo value;

    @property override TypeInfo next() nothrow pure
    {
        return value;
    }

    @property override uint flags() nothrow pure { return 1; }

    @property override size_t talign() nothrow pure
    {
        return (void[]).alignof;
    }

    version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
    {   //arg1 = typeid(size_t);
        //arg2 = typeid(void*);
        return 0;
    }
}

/**
 * Runtime type information about a class.
 * Can be retrieved from an object instance by using the
 * $(LINK2 ../property.html#classinfo, .classinfo) property.
 */
class TypeInfo_Class : TypeInfo
{
    override string toString() { return info.name; }

    override equals_t opEquals(Object o)
    {
        TypeInfo_Class c;
        return this is o ||
                ((c = cast(TypeInfo_Class)o) !is null &&
                 this.info.name == c.info.name);
    }

    override hash_t getHash(in void* p)
    {
        Object o = *cast(Object*)p;
        return o ? o.toHash() : 0;
    }

    override equals_t equals(in void* p1, in void* p2)
    {
        Object o1 = *cast(Object*)p1;
        Object o2 = *cast(Object*)p2;

        return (o1 is o2) || (o1 && o1.opEquals(o2));
    }

    override int compare(in void* p1, in void* p2)
    {
        Object o1 = *cast(Object*)p1;
        Object o2 = *cast(Object*)p2;
        int c = 0;

        // Regard null references as always being "less than"
        if (o1 !is o2)
        {
            if (o1)
            {
                if (!o2)
                    c = 1;
                else
                    c = o1.opCmp(o2);
            }
            else
                c = -1;
        }
        return c;
    }

    @property override size_t tsize() nothrow pure
    {
        return Object.sizeof;
    }

    @property override uint flags() nothrow pure { return 1; }

    @property override OffsetTypeInfo[] offTi() nothrow pure
    {
        return m_offTi;
    }

    @property TypeInfo_Class info() nothrow pure { return this; }
    @property TypeInfo typeinfo() nothrow pure { return this; }

    byte[]      init;           /** class static initializer
                                 * (init.length gives size in bytes of class)
                                 */
    string      name;           /// class name
    void*[]     vtbl;           /// virtual function pointer table
    Interface[] interfaces;     /// interfaces this class implements
    TypeInfo_Class   base;           /// base class
    void*       destructor;
    void function(Object) classInvariant;
    uint        m_flags;
    //  1:                      // is IUnknown or is derived from IUnknown
    //  2:                      // has no possible pointers into GC memory
    //  4:                      // has offTi[] member
    //  8:                      // has constructors
    // 16:                      // has xgetMembers member
    // 32:                      // has typeinfo member
    // 64:                      // is not constructable
    void*       deallocator;
    OffsetTypeInfo[] m_offTi;
    void function(Object) defaultConstructor;   // default Constructor
    const(MemberInfo[]) function(in char[]) xgetMembers;

    /**
     * Search all modules for TypeInfo_Class corresponding to classname.
     * Returns: null if not found
     */
    static TypeInfo_Class find(in char[] classname)
    {
        foreach (m; ModuleInfo)
        {
          if (m)
            //writefln("module %s, %d", m.name, m.localClasses.length);
            foreach (c; m.localClasses)
            {
                //writefln("\tclass %s", c.name);
                if (c.name == classname)
                    return c;
            }
        }
        return null;
    }

    /**
     * Create instance of Object represented by 'this'.
     */
    Object create()
    {
        if (m_flags & 8 && !defaultConstructor)
            return null;
        if (m_flags & 64) // abstract
            return null;
        Object o = _d_newclass(this);
        if (m_flags & 8 && defaultConstructor)
        {
            defaultConstructor(o);
        }
        return o;
    }

    /**
     * Search for all members with the name 'name'.
     * If name[] is null, return all members.
     */
    const(MemberInfo[]) getMembers(in char[] name)
    {
        if (m_flags & 16 && xgetMembers)
            return xgetMembers(name);
        return null;
    }
}

alias TypeInfo_Class ClassInfo;

class TypeInfo_Interface : TypeInfo
{
    override string toString() { return info.name; }

    override equals_t opEquals(Object o)
    {
        TypeInfo_Interface c;
        return this is o ||
                ((c = cast(TypeInfo_Interface)o) !is null &&
                 this.info.name == c.classinfo.name);
    }

    override hash_t getHash(in void* p)
    {
        Interface* pi = **cast(Interface ***)*cast(void**)p;
        Object o = cast(Object)(*cast(void**)p - pi.offset);
        assert(o);
        return o.toHash();
    }

    override equals_t equals(in void* p1, in void* p2)
    {
        Interface* pi = **cast(Interface ***)*cast(void**)p1;
        Object o1 = cast(Object)(*cast(void**)p1 - pi.offset);
        pi = **cast(Interface ***)*cast(void**)p2;
        Object o2 = cast(Object)(*cast(void**)p2 - pi.offset);

        return o1 == o2 || (o1 && o1.opCmp(o2) == 0);
    }

    override int compare(in void* p1, in void* p2)
    {
        Interface* pi = **cast(Interface ***)*cast(void**)p1;
        Object o1 = cast(Object)(*cast(void**)p1 - pi.offset);
        pi = **cast(Interface ***)*cast(void**)p2;
        Object o2 = cast(Object)(*cast(void**)p2 - pi.offset);
        int c = 0;

        // Regard null references as always being "less than"
        if (o1 != o2)
        {
            if (o1)
            {
                if (!o2)
                    c = 1;
                else
                    c = o1.opCmp(o2);
            }
            else
                c = -1;
        }
        return c;
    }

    @property override size_t tsize() nothrow pure
    {
        return Object.sizeof;
    }

    @property override uint flags() nothrow pure { return 1; }

    TypeInfo_Class info;
}

class TypeInfo_Struct : TypeInfo
{
    override string toString() { return name; }

    override equals_t opEquals(Object o)
    {
        TypeInfo_Struct s;
        return this is o ||
                ((s = cast(TypeInfo_Struct)o) !is null &&
                 this.name == s.name &&
                 this.init.length == s.init.length);
    }

    override hash_t getHash(in void* p)
    {
        assert(p);
        if (xtoHash)
        {
            debug(PRINTF) printf("getHash() using xtoHash\n");
            return (*xtoHash)(p);
        }
        else
        {
            debug(PRINTF) printf("getHash() using default hash\n");
            return hashOf(p, init.length);
        }
    }

    override equals_t equals(in void* p1, in void* p2)
    {
        if (!p1 || !p2)
            return false;
        else if (xopEquals)
            return (*xopEquals)(p1, p2);
        else if (p1 == p2)
            return true;
        else
            // BUG: relies on the GC not moving objects
            return memcmp(p1, p2, init.length) == 0;
    }

    override int compare(in void* p1, in void* p2)
    {
        // Regard null references as always being "less than"
        if (p1 != p2)
        {
            if (p1)
            {
                if (!p2)
                    return true;
                else if (xopCmp)
                    return (*xopCmp)(p2, p1);
                else
                    // BUG: relies on the GC not moving objects
                    return memcmp(p1, p2, init.length);
            }
            else
                return -1;
        }
        return 0;
    }

    @property override size_t tsize() nothrow pure
    {
        return init.length;
    }

    override void[] init() nothrow pure { return m_init; }

    @property override uint flags() nothrow pure { return m_flags; }

    @property override size_t talign() nothrow pure { return m_align; }

    override void destroy(void* p)
    {
        if (xdtor)
            (*xdtor)(p);
    }

    override void postblit(void* p)
    {
        if (xpostblit)
            (*xpostblit)(p);
    }

    string name;
    void[] m_init;      // initializer; init.ptr == null if 0 initialize

    hash_t   function(in void*)           xtoHash;
    equals_t function(in void*, in void*) xopEquals;
    int      function(in void*, in void*) xopCmp;
    char[]   function(in void*)           xtoString;

    uint m_flags;

    const(MemberInfo[]) function(in char[]) xgetMembers;
    void function(void*)                    xdtor;
    void function(void*)                    xpostblit;

    uint m_align;

    version (X86_64)
    {
        override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
        {   arg1 = m_arg1;
            arg2 = m_arg2;
            return 0;
        }
        TypeInfo m_arg1;
        TypeInfo m_arg2;
    }
}

unittest
{
    struct S
    {
        const bool opEquals(ref const S rhs)
        {
            return false;
        }
    }
    S s;
    assert(!typeid(S).equals(&s, &s));
}

class TypeInfo_Const : TypeInfo
{
    override string toString()
    {
        return cast(string) ("const(" ~ base.toString() ~ ")");
    }

    //override equals_t opEquals(Object o) { return base.opEquals(o); }
    override equals_t opEquals(Object o)
    {
        if (this is o)
            return true;

        if (typeid(this) != typeid(o))
            return false;

        auto t = cast(TypeInfo_Const)o;
        if (base.opEquals(t.base))
        {
            return true;
        }
        return false;
    }

    override hash_t getHash(in void *p) { return base.getHash(p); }
    override equals_t equals(in void *p1, in void *p2) { return base.equals(p1, p2); }
    override int compare(in void *p1, in void *p2) { return base.compare(p1, p2); }
    @property override size_t tsize() nothrow pure { return base.tsize; }
    override void swap(void *p1, void *p2) { return base.swap(p1, p2); }

    @property override TypeInfo next() nothrow pure { return base.next; }
    @property override uint flags() nothrow pure { return base.flags; }
    override void[] init() nothrow pure { return base.init; }

    @property override size_t talign() nothrow pure { return base.talign(); }

    version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
    {   return base.argTypes(arg1, arg2);
    }

    TypeInfo base;
}

abstract class MemberInfo
{
    @property string name() nothrow pure;
}

///////////////////////////////////////////////////////////////////////////////
// Throwable
///////////////////////////////////////////////////////////////////////////////


class Throwable : Object
{
    interface TraceInfo
    {
        int opApply(scope int delegate(ref char[]));
        int opApply(scope int delegate(ref size_t, ref char[]));
        string toString();
    }

    string      msg;
    string      file;
    size_t      line;
    TraceInfo   info;
    Throwable   next;

    this(string msg, Throwable next = null)
    {
        this.msg = msg;
        this.next = next;
        //this.info = _d_traceContext();
    }

    this(string msg, string file, size_t line, Throwable next = null)
    {
        this(msg, next);
        this.file = file;
        this.line = line;
        //this.info = _d_traceContext();
    }

    override string toString()
    {
        char[20] tmp = void;
        char[]   buf;

        if (file)
        {
           buf ~= this.classinfo.name ~ "@" ~ file ~ "(" ~ tmp.intToString(line) ~ ")";
        }
        else
        {
            buf ~= this.classinfo.name;
        }
        if (msg)
        {
            buf ~= ": " ~ msg;
        }
        if (info)
        {
            buf ~= "\n----------------";
            foreach (t; info)
                buf ~= "\n" ~ t;
        }
        return cast(string) buf;
    }
}


class Exception : Throwable
{

    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null)
    {
        super(msg, file, line, next);
    }

    this(string msg, Throwable next, string file = __FILE__, size_t line = __LINE__)
    {
        super(msg, file, line, next);
    }
}

///////////////////////////////////////////////////////////////////////////////
// ModuleInfo
///////////////////////////////////////////////////////////////////////////////


enum
{
    MIctorstart  = 1,   // we've started constructing it
    MIctordone   = 2,   // finished construction
    MIstandalone = 4,   // module ctor does not depend on other module
                        // ctors being done first
    MItlsctor    = 8,
    MItlsdtor    = 0x10,
    MIctor       = 0x20,
    MIdtor       = 0x40,
    MIxgetMembers = 0x80,
    MIictor      = 0x100,
    MIunitTest   = 0x200,
    MIimportedModules = 0x400,
    MIlocalClasses = 0x800,
    MInew        = 0x80000000        // it's the "new" layout
}


struct ModuleInfo
{
    struct New
    {
        uint flags;
        uint index;                        // index into _moduleinfo_array[]

        /* Order of appearance, depending on flags
         * tlsctor
         * tlsdtor
         * xgetMembers
         * ctor
         * dtor
         * ictor
         * importedModules
         * localClasses
         * name
         */
    }
    struct Old
    {
        string          name;
        ModuleInfo*[]    importedModules;
        TypeInfo_Class[]     localClasses;
        uint            flags;

        void function() ctor;       // module shared static constructor (order dependent)
        void function() dtor;       // module shared static destructor
        void function() unitTest;   // module unit tests

        void* xgetMembers;          // module getMembers() function

        void function() ictor;      // module shared static constructor (order independent)

        void function() tlsctor;        // module thread local static constructor (order dependent)
        void function() tlsdtor;        // module thread local static destructor

        uint index;                        // index into _moduleinfo_array[]

        void*[1] reserved;          // for future expansion
    }

    union
    {
        New n;
        Old o;
    }

    @property bool isNew() nothrow pure { return (n.flags & MInew) != 0; }

    @property uint index() nothrow pure { return isNew ? n.index : o.index; }
    @property void index(uint i) nothrow pure { if (isNew) n.index = i; else o.index = i; }

    @property uint flags() nothrow pure { return isNew ? n.flags : o.flags; }
    @property void flags(uint f) nothrow pure { if (isNew) n.flags = f; else o.flags = f; }

    @property void function() tlsctor() nothrow pure
    {
        if (isNew)
        {
            if (n.flags & MItlsctor)
            {
                size_t off = New.sizeof;
                return *cast(typeof(return)*)(cast(void*)(&this) + off);
            }
            return null;
        }
        else
            return o.tlsctor;
    }

    @property void function() tlsdtor() nothrow pure
    {
        if (isNew)
        {
            if (n.flags & MItlsdtor)
            {
                size_t off = New.sizeof;
                if (n.flags & MItlsctor)
                    off += o.tlsctor.sizeof;
                return *cast(typeof(return)*)(cast(void*)(&this) + off);
            }
            return null;
        }
        else
            return o.tlsdtor;
    }

    @property void* xgetMembers() nothrow pure
    {
        if (isNew)
        {
            if (n.flags & MIxgetMembers)
            {
                size_t off = New.sizeof;
                if (n.flags & MItlsctor)
                    off += o.tlsctor.sizeof;
                if (n.flags & MItlsdtor)
                    off += o.tlsdtor.sizeof;
                return *cast(typeof(return)*)(cast(void*)(&this) + off);
            }
            return null;
        }
        return o.xgetMembers;
    }

    @property void function() ctor() nothrow pure
    {
        if (isNew)
        {
            if (n.flags & MIctor)
            {
                size_t off = New.sizeof;
                if (n.flags & MItlsctor)
                    off += o.tlsctor.sizeof;
                if (n.flags & MItlsdtor)
                    off += o.tlsdtor.sizeof;
                if (n.flags & MIxgetMembers)
                    off += o.xgetMembers.sizeof;
                return *cast(typeof(return)*)(cast(void*)(&this) + off);
            }
            return null;
        }
        return o.ctor;
    }

    @property void function() dtor() nothrow pure
    {
        if (isNew)
        {
            if (n.flags & MIdtor)
            {
                size_t off = New.sizeof;
                if (n.flags & MItlsctor)
                    off += o.tlsctor.sizeof;
                if (n.flags & MItlsdtor)
                    off += o.tlsdtor.sizeof;
                if (n.flags & MIxgetMembers)
                    off += o.xgetMembers.sizeof;
                if (n.flags & MIctor)
                    off += o.ctor.sizeof;
                return *cast(typeof(return)*)(cast(void*)(&this) + off);
            }
            return null;
        }
        return o.ctor;
    }

    @property void function() ictor() nothrow pure
    {
        if (isNew)
        {
            if (n.flags & MIictor)
            {
                size_t off = New.sizeof;
                if (n.flags & MItlsctor)
                    off += o.tlsctor.sizeof;
                if (n.flags & MItlsdtor)
                    off += o.tlsdtor.sizeof;
                if (n.flags & MIxgetMembers)
                    off += o.xgetMembers.sizeof;
                if (n.flags & MIctor)
                    off += o.ctor.sizeof;
                if (n.flags & MIdtor)
                    off += o.ctor.sizeof;
                return *cast(typeof(return)*)(cast(void*)(&this) + off);
            }
            return null;
        }
        return o.ictor;
    }

    @property void function() unitTest() nothrow pure
    {
        if (isNew)
        {
            if (n.flags & MIunitTest)
            {
                size_t off = New.sizeof;
                if (n.flags & MItlsctor)
                    off += o.tlsctor.sizeof;
                if (n.flags & MItlsdtor)
                    off += o.tlsdtor.sizeof;
                if (n.flags & MIxgetMembers)
                    off += o.xgetMembers.sizeof;
                if (n.flags & MIctor)
                    off += o.ctor.sizeof;
                if (n.flags & MIdtor)
                    off += o.ctor.sizeof;
                if (n.flags & MIictor)
                    off += o.ictor.sizeof;
                return *cast(typeof(return)*)(cast(void*)(&this) + off);
            }
            return null;
        }
        return o.unitTest;
    }

    @property ModuleInfo*[] importedModules() nothrow pure
    {
        if (isNew)
        {
            if (n.flags & MIimportedModules)
            {
                size_t off = New.sizeof;
                if (n.flags & MItlsctor)
                    off += o.tlsctor.sizeof;
                if (n.flags & MItlsdtor)
                    off += o.tlsdtor.sizeof;
                if (n.flags & MIxgetMembers)
                    off += o.xgetMembers.sizeof;
                if (n.flags & MIctor)
                    off += o.ctor.sizeof;
                if (n.flags & MIdtor)
                    off += o.ctor.sizeof;
                if (n.flags & MIictor)
                    off += o.ictor.sizeof;
                if (n.flags & MIunitTest)
                    off += o.unitTest.sizeof;
                auto plength = cast(size_t*)(cast(void*)(&this) + off);
                ModuleInfo** pm = cast(ModuleInfo**)(plength + 1);
                return pm[0 .. *plength];
            }
            return null;
        }
        return o.importedModules;
    }

    @property TypeInfo_Class[] localClasses() nothrow pure
    {
        if (isNew)
        {
            if (n.flags & MIlocalClasses)
            {
                size_t off = New.sizeof;
                if (n.flags & MItlsctor)
                    off += o.tlsctor.sizeof;
                if (n.flags & MItlsdtor)
                    off += o.tlsdtor.sizeof;
                if (n.flags & MIxgetMembers)
                    off += o.xgetMembers.sizeof;
                if (n.flags & MIctor)
                    off += o.ctor.sizeof;
                if (n.flags & MIdtor)
                    off += o.ctor.sizeof;
                if (n.flags & MIictor)
                    off += o.ictor.sizeof;
                if (n.flags & MIunitTest)
                    off += o.unitTest.sizeof;
                if (n.flags & MIimportedModules)
                {
                    auto plength = cast(size_t*)(cast(void*)(&this) + off);
                    off += size_t.sizeof + *plength * plength.sizeof;
                }
                auto plength = cast(size_t*)(cast(void*)(&this) + off);
                TypeInfo_Class* pt = cast(TypeInfo_Class*)(plength + 1);
                return pt[0 .. *plength];
            }
            return null;
        }
        return o.localClasses;
    }

    @property string name() nothrow pure
    {
        if (isNew)
        {
            size_t off = New.sizeof;
            if (n.flags & MItlsctor)
                off += o.tlsctor.sizeof;
            if (n.flags & MItlsdtor)
                off += o.tlsdtor.sizeof;
            if (n.flags & MIxgetMembers)
                off += o.xgetMembers.sizeof;
            if (n.flags & MIctor)
                off += o.ctor.sizeof;
            if (n.flags & MIdtor)
                off += o.ctor.sizeof;
            if (n.flags & MIictor)
                off += o.ictor.sizeof;
            if (n.flags & MIunitTest)
                off += o.unitTest.sizeof;
            if (n.flags & MIimportedModules)
            {
                auto plength = cast(size_t*)(cast(void*)(&this) + off);
                off += size_t.sizeof + *plength * plength.sizeof;
            }
            if (n.flags & MIlocalClasses)
            {
                auto plength = cast(size_t*)(cast(void*)(&this) + off);
                off += size_t.sizeof + *plength * plength.sizeof;
            }
            auto p = cast(immutable(char)*)(cast(void*)(&this) + off);
            auto len = strlen(p);
            return p[0 .. len];
        }
        return o.name;
    }


    static int opApply(scope int delegate(ref ModuleInfo*) dg)
    {
        int ret = 0;

        foreach (m; _moduleinfo_array)
        {
            // TODO: Should null ModuleInfo be allowed?
            if (m !is null)
            {
                ret = dg(m);
                if (ret)
                    break;
            }
        }
        return ret;
    }
}


// Windows: this gets initialized by minit.asm
// Posix: this gets initialized in _moduleCtor()
extern (C) __gshared ModuleInfo*[] _moduleinfo_array;


