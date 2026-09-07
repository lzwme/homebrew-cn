class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.12.1.tar.gz"
  sha256 "1ae8103ab9d20d0621992eccefb6e8bad6553170b497db2ba9581b13a31ee5ea"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64cee605ae9669e7f8aff99c2bd1a1d9195677b53f57f779ec1dc8497af29719"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ac39aa31118988ead04117ba965a771d45352496b389c2d1adfb16203b4a914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1397dc7de5cfc95be9857c6b6b8bd7c0858556d50b3c53bd32965bd8bae998e"
    sha256 cellar: :any,                 arm64_linux:   "af8e9ca1c860523c1d78d967caac0fddd67ce84bf3295fbc207813b64519e12c"
    sha256 cellar: :any,                 x86_64_linux:  "40a9d9055261e1e8c0ce93de4dc796104d2be88d34e6d5edc0ea3e4e476b46f8"
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