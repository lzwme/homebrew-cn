class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.26.2.tar.gz"
  sha256 "f102c5dff2e20955f8e5ca69512b1375ea0071a6ff7e4f5d26cfd9397daea27b"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ae636d4b27a3cd0f7a505f152cbc5c6350f46fe053ac58ea790fdb0f93a2aba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c533e3d45786994b9f1008a7e44cd07b99594cf05f1dd77d790ab24b33eddb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b7817d7605ebc610b92b1d44fc4007d9a999bf70da68c50707e1af685922a58"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d39344ba1a7735217b7b8fd78c5b5ef847909c88b439ae8a6952afee2577b57"
    sha256 cellar: :any,                 arm64_linux:   "51dd6a59744802bcfd24575540f79763af4fa394b4e8c05a5f3835006989d503"
    sha256 cellar: :any,                 x86_64_linux:  "417e17d2c9c58fd93983f65ab1d20b8db696cc027d63fde4b345e5798d18e3b9"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end