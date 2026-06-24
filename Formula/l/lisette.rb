class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.4.4.tar.gz"
  sha256 "9cd781f3883e2affdbdd55b40b4aa7b7b49b7c73dac970107d3472634421560e"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28a3949e8ed9b49fb7aa06af7853a96ce413e91963e79fbde5081c8f028f6908"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a365d474e84343031676402954ac059c006d67076f304968dc9d608a336fa068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4da0d7ee39dd25eee70bd24de162c490fa4a7cb36768665705568f01e65beb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ce192c6706a87a6a76c254a99be751856ddc7e6791721d583929fddff2b7fb2"
    sha256 cellar: :any,                 arm64_linux:   "dd8e449eb64a5972077a3d095637c1e543427d73f13102a70852fdf09a972b46"
    sha256 cellar: :any,                 x86_64_linux:  "a0fc297dce74a1e7d28b789a7caaba76645876fe9ed025e98612b0301e0a1327"
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