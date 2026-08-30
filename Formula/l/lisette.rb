class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.12.0.tar.gz"
  sha256 "c4f200d25916c360869837a82aeaf215d3f5617520912a74c3cc3fab16e5148e"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "141b1489eba3d70f86e17c834224607a41cd608c239edf104e3bcc3411d03b87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68243b88367c79565a376dbcaffc44f351eabf767f8bb514f27032bff37d2182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac93b8d38470294866ff06c41f64abec17c3c84e91e96bf3529591c9b4a3bc72"
    sha256 cellar: :any,                 arm64_linux:   "c77d7a4c6266e224ca72cf55cefd440ab0bdba007fe9c7c2aaadd87f779ea12e"
    sha256 cellar: :any,                 x86_64_linux:  "7bf08e5828f6082881435687915621e4eba161c1f3d35a4450b8b75eb8861e30"
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