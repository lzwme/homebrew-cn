class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.2.16.tar.gz"
  sha256 "dbbf9d0f4d4ec5ba0ab9c01fa1a3c5c14b8fe023d19efab66acfbc696090a481"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37352749b3023a16b9937741f3e63411c0f2de929f567c36f726fbcde7e8d821"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "033a90c0390d0bb20c08345ffc12be7ab3bd5e397140a194d6bdffb96b2a1847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65d932d5a968aac2dad155205c88a3b1470f1ccf9cd86fab2c5206c0e77f3658"
    sha256 cellar: :any_skip_relocation, sonoma:        "0de67830b4773a3c4d915cfa65cd5b60650477733235015216a946dd2a5c2492"
    sha256 cellar: :any,                 arm64_linux:   "42dc265a5972d7195d84f6821b13416c5559279a03a1601699d7a0bff0a8455b"
    sha256 cellar: :any,                 x86_64_linux:  "484a1c02ed7dd82a3c9a3773c49e3dcebf2e7b1cf550363d1d889b9a46fb6f7e"
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