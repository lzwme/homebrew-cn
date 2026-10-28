class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "e57de05c5e92f99afb756ff52309892f8dff3ec1218b7073fb4877daec85dd81"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7586d50511638995081b15abc173a4da93de611b0cf176d1e4e3f9ba3c9d817"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9fa1664e37c44606b88419705fea79292082b7d2053a2482e9650bcc9ea70da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e55d9d76159e68992a8696f817e45a61ea6fd9b42cbec683860a13c84228c71"
    sha256 cellar: :any,                 arm64_linux:       "048ad51b9f1f914f2e6dc68f4af887ebc45b04aae4334388e8d75eb2816322d6"
    sha256 cellar: :any,                 x86_64_linux:      "5a36327d1b5581305b257485afbffe0875b52589230295dcb85dfb06b0e27cb8"
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