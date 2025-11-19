"""Unit tests for the hello module."""

import pytest
from nbn_dummy_package.hello import greet, main


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
