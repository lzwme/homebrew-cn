class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://ghproxy.com/https://github.com/tweag/nickel/archive/refs/tags/1.2.0.tar.gz"
  sha256 "d921831603f546e222e8be63818c67d5be2ac1c18066fad7eb7cf072a3c11612"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26b70fe64a7820c2a5f13033a286f0a68c4a01b9ce5b272688099fe98ee4e8ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5bd9f36cc525e87985dc8ced44b75bede19226d1e489c9291569c0725d8df86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "070e69c81c866b750c5e85cb9c7291c23b260e3bfe49d92f27776a633dce023b"
    sha256 cellar: :any_skip_relocation, ventura:        "1aee20f935436a073f716b6249487b02a5522636a16923816f9badff826976ba"
    sha256 cellar: :any_skip_relocation, monterey:       "2b983ee0b3707748a25054aa734f197058c0401b010f1c80531bd2056886e33c"
    sha256 cellar: :any_skip_relocation, big_sur:        "62f020042fc2a92a0de2cdde7589a8a926f2bc902ecc852d2d6205911b8156c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa15adcdda76766b1fee8552a403e0eaafd6985c1293b17b694d6ef16c89c51"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end