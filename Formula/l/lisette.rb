class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.10.0.tar.gz"
  sha256 "bcfb030058c3ec6fcc9e7e5e42325f702f7f63c973591ec347685397fee241c1"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c75a20df5a33fc4ab630a53be8bbe24392b6d2438872af95e817834103dfd2aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7459a46c6e0831ea3e4d56af16010800fc42a1c157c21e0d60dfbdecee09513a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eff35007c6bfd66a32cc85bfca0e3e545794a2f3f5b8586270befdc07c71754d"
    sha256 cellar: :any_skip_relocation, sonoma:        "96b8aa217754965dd86d14165549ff5348c8d75444b98f7ff7ba734fbcb7eda9"
    sha256 cellar: :any,                 arm64_linux:   "ee92cee2c21f110a59951a17ad419e8ddf7ae9f2913673023959179366fb2325"
    sha256 cellar: :any,                 x86_64_linux:  "c581877f80f289d05ae833dc9dc6056c82ac545a0ba3dc8ace37cf28108ec5bb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"lis", "complete")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lis version")

    (testpath/"hello.lis").write <<~LIS
      import "go:fmt"

      fn main() {
        fmt.Println("hello")
      }
    LIS
    system bin/"lis", "check", testpath/"hello.lis"
  end
end