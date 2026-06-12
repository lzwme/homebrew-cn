class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.3.4.tar.gz"
  sha256 "2463c36f1c2f8c647ab2f6c7ef452462472a27740b715cb2ce0cf15fc80b5faa"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68cbb6d1b77c9776eba3dd9bdf949646547b0f0701ac0159ae09377e8856e734"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4520b0c6d06c740b4724a17fd4e3796d181933dc200b6df0b58e56c4539eaa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d86a8853a7d921cbaed7c83ddcd62394f58067eca92e580843b5e84744858fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "85f614bffc2571fff70ee856fc8f311ee070cb575180f7ce53ba902c03eba41e"
    sha256 cellar: :any,                 arm64_linux:   "857686288237c56d03d484a34e91cba3da3054462ed5c8885b4c6f967bd1dcb1"
    sha256 cellar: :any,                 x86_64_linux:  "aefb1f076c7dab76d2fff5e1206acc16094bee2147d341dd5988e66b2a935fd6"
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