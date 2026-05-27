class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.23.1.tar.gz"
  sha256 "7680e7770b124f94231576e9387b7a23c4b375a0b90dae1e71d930921fc6b441"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc902a05664a0f05b048627a256fc586dfeb3c503f989e21263b0c8b8fff02c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb29180f91c9218e06f516dc063a16842f8a258f2d7c91ed9b77255a0334a8c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c18238cbcc5a26ab7c5f6a7c4829367f9294d9fe54f3eb90fa39174f4cca86"
    sha256 cellar: :any_skip_relocation, sonoma:        "090965f1894ea7fcf28f9c1fdaa186812e8a00b6dfe12640dfc8f02ecaac2aec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69c1b8c217d1411469654f8e975c33a386b2f4880e46d16fd9c41ffbe67c006a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e3efe8f1a986a01dcc53fbd2ec5d64ab9ce0d693091f6c36139eeef1c8d182"
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