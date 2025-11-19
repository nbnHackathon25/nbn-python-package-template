"""Unit tests for the hello module."""

import pytest
from nbn_dummy_package.hello import add, greet, main


class TestAdd:
    """Test cases for add function."""

    @pytest.mark.parametrize(
        "a,b,expected",
        [
            (1, 2, 3),
            (-1, 1, 0),
            (0, 0, 0),
            (100, 200, 300),
            (-5, -5, -10),
            (123456, 654321, 777777),
        ],
    )
    def test_add_parametrized(self, a: int, b: int, expected: int):
        """Test add with multiple inputs using parametrize."""
        result = add(a, b)
        assert result == expected

    def test_add_return_type(self):
        """Test that add returns an integer."""
        result = add(1, 2)
        assert isinstance(result, int)


class TestGreet:
    """Test cases for greet function."""

    def test_greet_default(self):
        """Test greet with default parameter."""
        result = greet()
        assert result == "Hello, World!"

    @pytest.mark.parametrize(
        "name,expected",
        [
            ("Alice", "Hello, Alice!"),
            ("Bob", "Hello, Bob!"),
            ("David E", "Hello, David E!"),
            ("", "Hello, !"),
            ("123", "Hello, 123!"),
            ("Test User", "Hello, Test User!"),
        ],
    )
    def test_greet_parametrized(self, name: str, expected: str):
        """Test greet with multiple names using parametrize."""
        result = greet(name)
        assert result == expected

    def test_greet_return_type(self):
        """Test that greet returns a string."""
        result = greet()
        assert isinstance(result, str)


class TestMain:
    """Test cases for main function."""

    def test_main_prints_hello_world(self, capsys):
        """Test that main function prints the expected output."""
        main()
        captured = capsys.readouterr()
        assert captured.out == "Hello, World!\n"
