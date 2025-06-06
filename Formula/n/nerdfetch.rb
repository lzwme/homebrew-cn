class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https:github.comThatOneCalculatorNerdFetch"
  url "https:github.comThatOneCalculatorNerdFetcharchiverefstagsv8.3.3.tar.gz"
  sha256 "2a132e365f0b26c0ae542de000a5204f8d6d168b4848465ec13af93bad46fa0d"
  license "MIT"
  head "https:github.comThatOneCalculatorNerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b19b0df53c7789d8d4d76f2dabdbf895330887b95506b20f5790d48f8e37afa9"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output(bin"nerdfetch")
  end
end