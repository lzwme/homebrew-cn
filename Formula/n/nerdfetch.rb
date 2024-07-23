class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https:github.comThatOneCalculatorNerdFetch"
  url "https:github.comThatOneCalculatorNerdFetcharchiverefstagsv8.2.0.tar.gz"
  sha256 "4f3063c4c31f0cb95fc50af5e418149eef6829fc92314031f3f69d5eb2a4a77c"
  license "MIT"
  head "https:github.comThatOneCalculatorNerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0eb25ab4dcbba8cc49be7b1bd3197bb5328d8dde061512e148b5ad38ee4b26b"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output("#{bin}nerdfetch")
  end
end