class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "6d60e118f17bc22a9842d5aea3fe9cfc467ae1eccd5f9b680afd4bbe0342a407"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39360f9d68c25ec2c998cf4ec60dd60b598c81a6589bfb74bcdaf14ce7e7667d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9088c100a196bece571b11ec76741dc77e161bfed3a3a0398cb15e035ca45264"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "274b11b4cbe47263ee329c0ffdf339f336782e404586806677c042d69dc938c8"
    sha256 cellar: :any,                 arm64_linux:       "fda8798f0a2e5b3814aa3d1a173c410a39871513eb8e134b344167f33c97868a"
    sha256 cellar: :any,                 x86_64_linux:      "7169d4caf3154a4db6cb3a06b1185cbf8d0cba8184e33eab22c934cd9e093ffa"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tgrep-cli")
  end

  test do
    (testpath/"src").mkpath
    (testpath/"src/main.rs").write <<~RUST
      fn main() {
          println!("hello trigram");
      }
    RUST
    (testpath/"src/lib.rs").write <<~RUST
      pub fn helper() -> u32 { 42 }
    RUST
    (testpath/"notes.txt").write "nothing to see here\n"

    system bin/"tgrep", "index", testpath

    matches = shell_output("#{bin}/tgrep 'hello trigram' #{testpath}")
    assert_match "src/main.rs", matches
    assert_match "hello trigram", matches

    assert_match version.to_s, shell_output("#{bin}/tgrep --version")
  end
end