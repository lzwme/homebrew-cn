class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/v0.30.0.tar.gz"
  sha256 "40a1a05451785e88a955c63726a02c43d2a46134da0a6ac0824f39d50ed56d36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8154f40f1ed60d72d8be5c871996c73eb05194b4f1be66ad9588687166b0f2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60677bbc0fdc7ab0425900e3f7e637130519597563c1eb09062b40545194a2c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "231e0d64ccb9c015ad5cf03e14b9eaaccfecd005032cc9f0c94312ffab280a02"
    sha256 cellar: :any_skip_relocation, ventura:        "6f4330cc5fed5e61d213f2645e9bde4ef0600fb2378978209990507b6e1354ce"
    sha256 cellar: :any_skip_relocation, monterey:       "29d428ec8c2b30e8cbc16c2825b5e4d4eef1e189593ea637a9fef7c4bdde6e0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d557511c0f82743469c1d87f173a61ae9dbb93a163df10e99c5df27281c042f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "420e57d3ffc67a959cfded718ae43596504d07ef87ad25624f9caa1f1db25921"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end