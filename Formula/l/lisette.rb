class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.4.3.tar.gz"
  sha256 "d57acd24fe66815ad7421482920c8b8b3dcf1f3795f03b992d9f11e9fe453b51"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "286fb1869278f6ba8c91f632f06a51bd67eb07a8c05ba5a5ba59e792eb5a38c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616b7293ba86585d0c014d6e90c8c6762a7b70895ca6e71a403dd7f3d0546354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "317d0507dfb2bd68c98856826c025f2d1e62a3a30dbeba6c44e2016a71871185"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6c892c98722cfef5765698d118605957934c5ded24afe7b174fd43472e5cfcf"
    sha256 cellar: :any,                 arm64_linux:   "9e2932f4f8d501307a7c6b1826b8d69acb485660ff2ca6cf8def7c0e7d6ef46f"
    sha256 cellar: :any,                 x86_64_linux:  "fcb3d4149eceeb01ba82db6e8fab62c1ebb846f081e74e64379ed306908c1136"
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