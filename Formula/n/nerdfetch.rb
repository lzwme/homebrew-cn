class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https://github.com/ThatOneCalculator/NerdFetch"
  url "https://ghfast.top/https://github.com/ThatOneCalculator/NerdFetch/archive/refs/tags/v8.5.1.tar.gz"
  sha256 "5c9d3ef573050188f3efc6b903b8ededbfd0e61c7342a4ea327c2c8c5434b84e"
  license "MIT"
  head "https://github.com/ThatOneCalculator/NerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea27056f713cf84203fe036d6936a2f384493541259a5b1f20d04df593365d2c"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output(bin/"nerdfetch")
  end
end