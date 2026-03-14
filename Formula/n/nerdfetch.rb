class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https://github.com/ThatOneCalculator/NerdFetch"
  url "https://ghfast.top/https://github.com/ThatOneCalculator/NerdFetch/archive/refs/tags/v8.5.3.tar.gz"
  sha256 "5ff5ca8abb4c33dfb603aa9ef58cf1b577f4d8f1abe07edf35a767deefb35605"
  license "MIT"
  head "https://github.com/ThatOneCalculator/NerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6721af303394d6fb63df3017f5c41b821a502de1f21b93128697270b1e3d5a86"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output(bin/"nerdfetch")
  end
end