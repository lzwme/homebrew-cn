class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.13.9.tar.gz"
  sha256 "bcb358af258233100dbe60ae341f79ab5db520f5207dbe52f94ff525d6d322f0"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fa660a96989a21be160a634cd5a6f4b5f59c1f93cf9d5040aeb0473fd61ce9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccbf55d281b89fb4ecefa362a14a628f01303c61cf38f467b1c363c749bcc49a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3be124c3a957fe4633eb675f736d1833e093bb400fe2909c9547b98c32acdc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dab2ab8ba9b4300d817d5237e7f6a7f7bc996a0853e3a75fd1531146bfbb201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a388c8e4bfa2f4147c826be24b4059b29fc1b60f91b4feadafafe80a4d2af001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e74d35f13bfa7ca4deff40ffe88f1fc45b105937f92956d72971477f4710f9c3"
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