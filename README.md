# gors

This is successor of [sahl](https://github.com/abooishaaq/sahl).<br/>
It would be insipred by Go and Rust and would be a high level programming language.<br/>
<s>Runtime would be backed by generational GC and it would compile to native code using llvm.</s><br/>
Just transpile it to go.
Here is how I want the v0.1.0 to look like.

## Types

```rust
bool,
f32, f64,
u8, u16, u32, u64,
i8, i16, i32, i64,
char, string,
list<T> # lists
(T, T, T) # tuples
map<T, T> # maps
->chan<T>, // send only channel
<-chan<T>, // receive only channel
&T # references
&mut T # mutable references
```

`&mut T` won't be allowed to be passed to coroutines as argument or via channels.<br/>
The only way of communicating with coroutines would be through channels.<br/>
Also, `chan`s can be either send only or receive only. And only primitives and references can be sent through channels.<br/>

### structs

```rust
struct Point {
    x: f32,
    y: f32,
}
```

### generics

```rust
struct Pair<T> {
    first: T,
    second: T,
}
```

### traits

```rust
trait Shape {
    fn area() -> f32;
    fn perimeter(&self) -> f32;
}
```

### impl

```rust
impl Shape for Point {
    fn area(&self) -> f32 {
        self.x * self.y
    }
    fn perimeter(&self) -> f32 {
        2 * (self.x + self.y)
    }
    fn mutate(&mut self) {
        self.x = 0;
        self.y = 0;
    } // this can't be called as a coroutine
}
```

## example tcp server

This is the ideal one would look like.

```rust
fn handle(conn: net::Conn, inform_recvd: ->chan<&list<u8>>) {
    let mut buf = make([u8], 1024); // 1024 capacity
    while true {
        let res = conn.read(&mut buf); // result<(), net::Err>
        match res {
            Ok(()) => {
                inform_recvd <- &buf; // can only send primitives and references
                conn.write(&buf);
            }
            Err(e) => {
                println("Terminated Client: $e"); // $e is string interpolation
                break;
            }
        }
    }
}

fn main() {
    let list_res = net::listen(1337); // result<net::Listener, net::Err>
    let listn = if let Err(e) = list_res {
        println("Failed to listen: $e");
        return;
    } else {
        list_res.unwrap()
    }
    loop {
        let conn = listn.accept();
        let (send, recv) = make(chan<&list<u8>>);
        gors handle(conn, send);
        gors || { // capture a channel
            while true {
                let buf = <-recv;
                println("Received: $buf");
            }
        }; // an annonymous closure being called as a coroutine
    }
}
```

## syntax

#### for-in loops

```rust
for i in 0..=10 {
    println(i)
}
```

#### match

```rust
match res {
    Ok(()) => {
        println("Success")
    }
    Err(e) => {
        println("Error: $e")
    }
}
```

#### if-else

```rust

if res.is_ok() {
    println("Success")
} else {
    println("Error: $res")
}
```

#### while

```rust
let mut i = 0 
while i < 10 {
    println(i)
    i += 1
}
```


## Conclusion

I think this sums it up.
