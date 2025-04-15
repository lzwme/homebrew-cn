class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.11.7.tar.gz"
  sha256 "d3687a286b4813ab8534d7ce8653908dcf17ad291bc865f3f64c183163f0b650"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8a0248948272cec241a8a14ce69cdc37fbc150810d01302ef63cd455482300d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "930462fc0d2040c92339dcf3568330615e93d518fb326df2d0d9bf9ef20d464a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd932813fe911b16551853e79f9a66c813f5af78f26dea32351acb6334038c98"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ad329d873591bad2016dc45885a04b6809625edd2b6a80f4d0c03e058594a62"
    sha256 cellar: :any_skip_relocation, ventura:       "8bd31c1e751d9e8f4edd8aac96acf2d79b5a7a7b73e1cda312c96f9c68ec88eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1df2568426b7a2fcdbc121b80e4bef76b1e03ca1970e4dbd54e653a0feb3070a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b1a641e905c9785783f118473dae287a9dd118df1f21cc26c943eee46bd7236"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "mantv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end