class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.11.1.tar.gz"
  sha256 "1b54bbaddd91ffc7d8504105429a1502c89d022d7316a921cb16626f5044cce3"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2914d63eb9d69a8e8fa0267207512498b256d8da2ea6c0f5d3d8385f06c74f12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3657e7f718a27344282c750686dacb10c7348a20141fdeefe48653be6ec50bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da1a3bef340254aa9f97ffbffe4e4770c8962b5f000b01aae3fed111f3468145"
    sha256 cellar: :any_skip_relocation, sonoma:        "e630eebdc19f37ab3b8bb1bbc81c3e1c4bf4792c69d7fa75970f7e161e7cc1e3"
    sha256 cellar: :any,                 arm64_linux:   "7eecf0fb5add211296751ad08694bbe2895b51fe6681d5c606181a6fa687266c"
    sha256 cellar: :any,                 x86_64_linux:  "e8ee2a13dd4aa4b72a14eedeedfca602c30a0bdd7f1dfc8b4dbca74700ef2ba6"
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