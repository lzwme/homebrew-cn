class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.10.10.tar.gz"
  sha256 "fc7547d45d112599559434ad438bb05c7dab0484fae15d9fa5625069dc5b9687"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33b974022c7fe4420351150e3fb191a45e5416a5dd18a1980dd9643f14481cec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1784bf4575b632039b2c14fe5f1d8f8807c0bf766b2f5f42606ed44dcf5faa9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddb1109162d78cb02742841d4c03d85ce943ae513b9cb69d5df0140380bb8e9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "95bb7cd10da68a3bd2a41090460e31f691067ae244e73d791b426bf21cf6af44"
    sha256 cellar: :any_skip_relocation, ventura:       "69ca3fd713f28335bb0951172bd1d810a55a1ce59f4837e90ea2f6a83e382a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7cd6152e694c34928b23600117bedbf3fa635bf38340c4a7ac28c293b125ac1"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end