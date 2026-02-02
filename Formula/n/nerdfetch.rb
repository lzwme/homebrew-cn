class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https://github.com/ThatOneCalculator/NerdFetch"
  url "https://ghfast.top/https://github.com/ThatOneCalculator/NerdFetch/archive/refs/tags/v8.5.0.tar.gz"
  sha256 "c2fb7e7fc33690a69b7beaf6473d56c882a44ba3bbe63150f45a97f107220741"
  license "MIT"
  head "https://github.com/ThatOneCalculator/NerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e83554df0abf2afdcb7b50a271c3fc35a3ec24619d6d2368e42e483fb6ad818"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output(bin/"nerdfetch")
  end
end