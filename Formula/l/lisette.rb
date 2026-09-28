class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.12.3.tar.gz"
  sha256 "e200cffc0ba554a98ceaf8bfa0377afec1298f0fb814079b51537863c6e73252"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15c042ead87c6037ab37061596add1fb561b5e27804888aa3c3f7b2b80a938df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93555052beb0bf8c2b9e7e4f3666c59b510a628ef87ccb6e84ac77d76d026843"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5d65edb3c374a5db3058709af918a1626da79bf6da23ec571d3cb07047d2917"
    sha256 cellar: :any,                 arm64_linux:       "49c02704faa03b9c53510b24850ce5cbaa2c3bc0213c41cc1810bf8c8d392a21"
    sha256 cellar: :any,                 x86_64_linux:      "27a0f31f2300cb2dd5e73075faef7eb404bf12e9d25b5b23a97ae9b42901d26f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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