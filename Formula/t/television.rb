class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.13.0.tar.gz"
  sha256 "888e927824c454262b3233a20dc317a60ff56759f0925747f00155640566e0a4"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3795dafbe0d8bd9747756066e3c5bc846646e0abf344fd091501d5e31f5416e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b63b22282535954054aa880f0ef60b3ae2618bbb6ed5e9b1109c76b360364b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d066afa2886f96f068d7aebaefc2a7631146185f3cd8316923d94ac7328bddd"
    sha256 cellar: :any_skip_relocation, sonoma:        "81388caeef59a74b1438349de9e1c1193f2fa3fd915757c197ffe7e9380a6d6e"
    sha256 cellar: :any_skip_relocation, ventura:       "5e8bd692f6ca3b678d5f4f38851ff9a54ea6bfc52b193056f845d7f996e02171"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0da11a2c13c0defa58328ac5718b4d87c9868eec85890763addff8278b98f694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50c02910ceb0b27bafbd46a62be41f258e1062b7140cdcb4dbdabfaf2779f67e"
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