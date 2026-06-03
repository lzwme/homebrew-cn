class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.2.17.tar.gz"
  sha256 "4da67408ed23b01ff7f446c0defe57c62630740916b16807c3ce0b54879914f6"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "671c1e06bfa0f66d7a5033e39eb05f6d47942a0c814572322c1347b7200afe37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6259a9522e5abb8bd8b2a9b8d6f04349c2b57d5cc8a2a7d58190ff629d4c3673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84a50b2d0c140077609940f97265ffb9051f93cfdfb76860ea4f2b6758859155"
    sha256 cellar: :any_skip_relocation, sonoma:        "af744900f467945a3ae93e530ad21c60bf39008b0322a39855b4fba572fbabbf"
    sha256 cellar: :any,                 arm64_linux:   "a4dacd4df34e36200cebae8cbe9389d69d6a2108a80cda8fb73733717649b8ab"
    sha256 cellar: :any,                 x86_64_linux:  "5bd4033789991d51aa4cce5ea2e2322af6ad5542b130536a817319711cecbb55"
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