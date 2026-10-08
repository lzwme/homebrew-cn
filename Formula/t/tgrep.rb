class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "7a9f136ff8f52175231091ae7710dafb946fd85021efcb62ff5deca4bcb1ac09"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c9fd6827b6ddb21ff1c51d8d78163e0fcf5ed1447861ca4be3cc87c66f78918"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "baf8515933671816bee3dcb56ea8115df55f40bce2fd288f17815b2f1ecbfc08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6896e038fb02d9dd89a94979b4fbe1562c2ca52cb0367a5485c24dbe2828738"
    sha256 cellar: :any,                 arm64_linux:       "6c000351575a060b41e65995b31d81a9b9637a3289c8df72112f11417a61e6d9"
    sha256 cellar: :any,                 x86_64_linux:      "f99c6cc613168ae22d8bfc001a12d061f39247426a2188198c3d987d6bea5919"
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