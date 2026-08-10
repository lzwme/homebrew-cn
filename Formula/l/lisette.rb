class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.11.2.tar.gz"
  sha256 "3b3f1cb684b7273d95aae800aa7c2d102f46e1bc680c049b6f0981d23c8d067b"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "298fe1bb2c760e00b418c02091c433d224ae93d73f8cbee1b47403ae2090b7b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e2b8b5c3d9f5b6ba28eb7d593226a284aa4d905775e64f19940cbea2d7153c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "655f5b310f4cb94185180230404e09c159189ccbdd8b26251559f653175256c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2208417c92632aa0f728c4888663133b25e550c01925cc7d0d084a72b005c39"
    sha256 cellar: :any,                 arm64_linux:   "dca8c6f2f8b41f11b01ff6b0e888a7a1e7606d1f840c2ab6e9ac99c465b566f7"
    sha256 cellar: :any,                 x86_64_linux:  "d9be8121ed0f1e26c717b8edc8f8dad70131de4de6e65ca99a59306f47bc1fb5"
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