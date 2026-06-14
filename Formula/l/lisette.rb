class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.4.0.tar.gz"
  sha256 "91cb01baff6f952bb9f91517971387ca363bf38582acd71ba4c68145a1f8bbdf"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83ac0bdce9e32f034fdc8a1d892d5a0f8e3fe35ec1281a1b991a093edf420df5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b00b831d78dc7c79455634c710b49e90e36d21796784990eb9a0609763260485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77bdb02914d0a05aae8c6b44e2566b4ddd9a09f9fe5cd5afe26995e582d7a72a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4faa412beb30e7dd9d67b2e3c2f8fc38573a62d2c6040ee8f3b43577f2f1d0ed"
    sha256 cellar: :any,                 arm64_linux:   "6ae332ece8df15bc1acfa041ab8bdbb8305bb9e8142bd77c682b55565067108b"
    sha256 cellar: :any,                 x86_64_linux:  "7496e05a8c1152677f55d66dd543a79f92be050781fc4142fe675ca141103a72"
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