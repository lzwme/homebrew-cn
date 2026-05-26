class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.2.12.tar.gz"
  sha256 "bf20c6eab8af9314b1baca324436acc2e0b15f10f403e4d6e51b6ff5431bd131"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a90cba3456f3463dbe46f3b811cd90d93ff9b63003901621d662d7164f464edf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5cb392a9a18769a35a7a98d7c652a626e53024194f5b7440a1c965c2ef123a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b45c32510a0b65809f6c5e2ceba93f2b7385bd4b6be1bcd308fceccff9224f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2ae2a96373dbe7ab37ab8db1a2ceb27d5c4087200f0b01683af24558cd61451"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94bf40db86166e136b40e10d00f0c12381dd77742bdd689cf1567b42bd776651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7df79af977b2f181df2801c1bc87886018cc855dd6ffb6fd0ad10107030ad19f"
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