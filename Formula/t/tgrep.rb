class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "5de3595b01220e9648d0d9cf8b92d233a38ff088065abf8acbd620b9f8df891b"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ac398a8896845e737c4389987b72b8bb862f56c5a42f3e0919d330ff184b163"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fb3289ac6a1be9eba77fa03ab4dc521e5a2c6ae3b7aed225dae7be9c1fb5ce5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b97ce9a225b7fb6261454a7842704659868a25a4bb9d28e8039e8487f6e0ccc6"
    sha256 cellar: :any,                 arm64_linux:       "595bb8710b9cbce56cde7c236e09a9aa04cb8988d97feb8aace98a8d34fc9fcc"
    sha256 cellar: :any,                 x86_64_linux:      "c1517f2a0f54fbb20e3bdf4a642d418adbe1079ee97fcd8dd4e6ef30930227fb"
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