class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.14.1.tar.gz"
  sha256 "1022aeae12ba6098d2c6b50307af25af67d69c78d3a5785d35ef1db3bc1cfe1b"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9577bd942040b2fed023ab4acf361165edc10cfca639747d60c96d4c423007ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b83df9d5f642813425fc84049a2e51b2b30ee1a198a9d9ca184592ded8a48d46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06ec26fa13a3beef5465ff49411565173d5eb6c560c089adbfe0f06fbce405d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b27bf90537df1a72ae872e8ee126cc6658cc6c793df9a9f4ba0271f7f79192a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e48ea45ae37b58f2ec6eb11129a0d535c48bd27f6f28f6c0752ae82e9ccc0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e6db313388a6333a737cadcd31584d7bf3ea66a3dee3027f90879fc7d99ec6"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"

    generate_completions_from_executable(bin/"tv", "init")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "fuzzy finder for the terminal", output
  end
end