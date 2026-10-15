class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "5a0ca61b4c53679826b691b8193912e4789ae2df3b458fc2b8ddaceba4662af6"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83d0f613fb48ed7b639a99a4369fd72a4921c519e9c34a0625e0b0f990a55e3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22740445d22410f84804ff560c4ff2caa1e8171d7d2724447b204fedcbd41195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff3bbb022739b3115ccd99b5ed74b9dfbb06b41b82dfc9ea1afd2370f1954431"
    sha256 cellar: :any,                 arm64_linux:       "13bb7b2e7a12edeb34d08ea973cdae1f04e8495f0e5612ea8a425323318ec1fa"
    sha256 cellar: :any,                 x86_64_linux:      "e56a1cfd7063126c559635cd9951f516b5415af8ab62e0b527c5f1460c793e41"
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