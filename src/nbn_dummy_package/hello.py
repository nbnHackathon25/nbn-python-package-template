"""Simple hello world module."""


def add(a: int, b: int) -> int:
    return a + b


def greet(name: str = "World") -> str:
    return f"Hello, {name}!"


def main() -> None:
    message = greet()
    print(message)


if __name__ == "__main__":  # pragma: no cover
    main()
