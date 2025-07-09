class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.12.0.tar.gz"
  sha256 "3b1d4338a242cc091863df16be3abd573c86613b2161c7a40e288d4d9c5e2a29"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f487ab148898ee5a8a09cf38595a89ef8024d72f5bb6223cbb92fea5c3eb6e08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29844805a92ce4cb57c1aa33ce8bc382169a8b3e71bbddff9a9f347ee031fc63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1e902179437ab84c714763d3938ec8b729e1537a8d21f6e92b26b832558d021"
    sha256 cellar: :any_skip_relocation, sonoma:        "112d68460d5097719ef1d9fca3dd3fa2789cd5da6fdffd27ecd217b7b0b6e738"
    sha256 cellar: :any_skip_relocation, ventura:       "00ed0cdf3572459352834d70eca6e98647cf9a81eb8947b9c2ad448da055c75b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7589e3e251840bb0e0762e42a4480bdc0b1dc84501048c3d0ba6baade63f22b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cde6e69ecaeaf323c195f05ebc9b0fc0f2e35e0568dcc922b1f2f6ea3bb05f1"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "Cross-platform", output
  end
end