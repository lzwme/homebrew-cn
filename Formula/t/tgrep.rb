class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "3fd12a6f76186b5ee7c1072d9f60d5133028b10acea125b24fa6b813c04dd839"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c682f3e1ea0191fa4cda2deba1352df331ff5aff7c4de5426ffec10fc83d403"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ed093de8c1eefb7b2c87e5d4b923e45c03765a4707470999d871f11e13a9155"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9e29fb15ded1c27d13772b376a3e1801a9f5665542b0411083ab4f10f28491c"
    sha256 cellar: :any,                 arm64_linux:       "a6848ec2e092491642e84c50f151f213643978f6374c937263a1a7311a45e05c"
    sha256 cellar: :any,                 x86_64_linux:      "d321a0b9b1141a5639b0b13fd0b9c56f29b830ec2746f6d61fda3603a7f4eb40"
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