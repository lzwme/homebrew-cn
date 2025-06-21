class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https:github.commongodbkingfisher"
  url "https:github.commongodbkingfisherarchiverefstagsv1.10.0.tar.gz"
  sha256 "7184695f2ffe2eab2413af7f48e2962f83cf665d2525c13ade5427f389e313ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c515037f42076c4c04d4ea5e1e4871f76ce09d43910593a3e2d105507c1d58ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dba1ebe1f6743128eb9365da9943ed0105486312c9485fc476382af4cd14c2aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe2f635f28d56c4307a82b19385e65a6ad6e77dfe3056d91a008ea63f77ef4d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2902c8dcff4c388f39979464aeaa313a5e1a65ebdaecbcbe1d275b26bedcebbc"
    sha256 cellar: :any_skip_relocation, ventura:       "f485ef6147627546814773e30058eb4d1e4cec7d7fd90083603c32905dad67e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "770b3d80e2c35bbc295dcffeddb181ba76f18dbc54d43dca833b4f3a1b38826f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee16b3edf41046b99f22d0cf1f2cb1d18873400ad297955da814bba2a3c733fd"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kingfisher --version")

    output = shell_output(bin"kingfisher scan --git-url https:github.comhomebrew.github")
    assert_match "|Findings....................: 0", output
  end
end