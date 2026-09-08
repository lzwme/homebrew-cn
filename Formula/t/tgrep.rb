class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "c199dc73bd98d85a0ece8834e0353d528cada6dca315cac7af572a15e93a4e1f"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9064aff337f673464ca5d30ef9465f5e5e55441d8e1d9a9383752e36582c806c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "043077e3dc9c99c826574027d51b33711b84c0503f6a5f8eac1a8e8cb7c18222"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1f0eba3529976c41a3df62f283dfa27cc57d433a034f4869b284f47440955b6"
    sha256 cellar: :any,                 arm64_linux:   "a7de060ade8646613c9acbbeed6c55df55bf803ef578c45fc82921f45a9b025d"
    sha256 cellar: :any,                 x86_64_linux:  "657e6fe0b47dd9d3de3b88c825b030905aa02d1de0760498523458a7f1a7d49c"
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