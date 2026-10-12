class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "bb43c07b805b34cfc5fee3847ea97bbe00822dede0c7195cc9522e94f35449dc"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6da1003a902d100e04f84f7ceee81ba64633d7896ab7081a00d0a30e0cd913d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d783ddaf4934017cfabe45abfdb8354febdbd18d8d09a7922e45ab62d9928190"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0528cf37186fa8164fce0030656b062dd53701c8b24cd2b0aef39de1308920ab"
    sha256 cellar: :any,                 arm64_linux:       "40484b5378b101b91413cd7e76c056fe3dab5a768c316637ebd4ab953a3cdbd2"
    sha256 cellar: :any,                 x86_64_linux:      "05fc983e1154c431074e7b09109ce6fca0b103d56fac00b08913be06af04d65d"
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