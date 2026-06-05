class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.3.0.tar.gz"
  sha256 "603240495851c8975e29377f2131ad8eb34130811932b596dd002f2664205e39"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0cf66cf6cb8bd7d300a777857fe06080c52bd2b56efb0bfb292c80a1858c696"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "259700c8f69f04a81b8cdc690934fa776f8b57ffd7beffa5e40760e1a6e679b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e1b05c5b172f3872016f9e48ac2f242a035c907f91067cd9e5f1aa599d2ef77"
    sha256 cellar: :any_skip_relocation, sonoma:        "52eefd19f195c8da757d7a8760b78d2a49efb0731846021655fda934e3fca58e"
    sha256 cellar: :any,                 arm64_linux:   "f2825554eef7a1c72ed856f52eb4aeda706b238315357b9dd2f154adc0efcb0c"
    sha256 cellar: :any,                 x86_64_linux:  "facdad21d48cd7dde9858d85dc36f245f25edff8e1f387ebf63efb25c42105ad"
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