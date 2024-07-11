class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https:github.comThatOneCalculatorNerdFetch"
  url "https:github.comThatOneCalculatorNerdFetcharchiverefstagsv8.1.2.tar.gz"
  sha256 "aa7c63d190963dee9fa1bc68e426d56d965d544b0d1ce0b38a55d26278d71dd2"
  license "MIT"
  head "https:github.comThatOneCalculatorNerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b7f835fa0d1a49c346c49285bdba6d75c79ecce135415a980e12010ad39aa767"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output("#{bin}nerdfetch")
  end
end