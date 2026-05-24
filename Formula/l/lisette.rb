class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.2.11.tar.gz"
  sha256 "434aab61c6d80a2470675564b55c1fa76d1e793091fa2fc4d7bb65d0b0fbe33e"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37f2d2f3cc272fb6a76e64830d965e6115934faf639999fe4570ce34ed3374d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "281f8f77f886add70f4bb7eeb636eedb96d8810de04a5c58bc8069df6354033d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57704dffa5f87bf145764898e860764c75e9a4b8d72bac193da97c0e88ac9b51"
    sha256 cellar: :any_skip_relocation, sonoma:        "d936d4b9c21d0d68332ac6e077d26b9b456026b36461783ec5e24b0e4e4d879a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bac6fc85a864ea8f3749035105c8cbb6fb92a12296f18f0301bae4a80c293655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa79acf21404832838c286b0cbcd60385310a4a295fcdc4e7e18221c5f3e085c"
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