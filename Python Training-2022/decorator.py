#decorator function
def mydecorator(fn):
    def inner_function():       
        fn()
        print('How are you?')
    return inner_function
#applying decorator
@mydecorator
def greet():
  print('Hello! ', end='')
greet()
@mydecorator
def dosomething():
  print('I am doing something.', end='')
dosomething()
