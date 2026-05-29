class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.2.15.tar.gz"
  sha256 "fa66eed905d541f88fcea1ed5f5720c12d56ac0c92d0d6a137c29c35a5fa722e"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11cd30184978e8defbf2358006d3f8b0bf3099e704aabce41174b5ef84cab660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c20cd82f9ab35a5f4c892616048188681aef39d239570dc0db06345d15ad5f2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "140cd8d98fa2e74615f2f0c89d915a3b57540ef58815bb2d2365da8ec96ec52f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e7dfd6d9f5259caffa07f6441b46d31af4114bec63feb8bb72a32009353155e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca4a2f4f7d07b4223d593987eaf428676f345e1b736af4415dc519436f52b0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7317f3e4f942d1235334c3c1b8bf67ef16a43602e90fc48efdb80350fd86d4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"lis", "complete", shells: [:bash, :zsh, :fish])
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