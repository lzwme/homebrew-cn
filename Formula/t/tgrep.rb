class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "9c4af473d19a49ebf8803596fadea1b83e3154371805e00143a3f4bb8d2b6253"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16055ab30ad5591ffdf5fd9a98a641d3762b31653dc4fec25f80277c7578e342"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d8f07281023afeb7ca6f366d1d215c7c55e5684d515aae9ba7a66b5ace405ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7280a72411e2a5e368748e3c29d9ab3940ce914f6db5a901e603cbf59611f257"
    sha256 cellar: :any,                 arm64_linux:       "029dac220f8b06b27ad6fb6766939efa844b2307cbe42c07260e26136bb896a1"
    sha256 cellar: :any,                 x86_64_linux:      "57729d16628219c2a57dd55409d75a530c14174b02460ada2456201f71737d26"
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