class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.13.8.tar.gz"
  sha256 "db252ceb27d8cac92c9a09525ca95894a89754802409cf35e17b7bac5096bbcf"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1864c11cc95d91fd90b3aeb0a8873a5d385fe8c8bbcd5799ff1045f7b35122c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17fa78f84bcac37f09e045936d8aa5cccf8aca5dcba2b6d640a09308231c5a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e0b50bcb0bda8b0f3d089b8879b9c1d7ee0bda6d401ca794d593615468e3cc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "46e864981d02ba3e7c7df821b47d45c1a968494870689ebcc5dad22eb0b6218e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc09f998c7fe93329c1c74b577f9703ef48f76f01e0f7a895fbad1de6b193c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31cfb9888d715a2397139a365cc73b821f72bb55caad160f69a163abff75446"
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