class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https:github.comjaspervdjpatat"
  url "https:hackage.haskell.orgpackagepatat-0.14.0.0patat-0.14.0.0.tar.gz"
  sha256 "a89c193664f89c12c04b7c6350ed03ce2de862dd30d1a1ee413c7169c1e08084"
  license "GPL-2.0-or-later"
  head "https:github.comjaspervdjpatat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67ec4051e5537bd63f8c7fd1562d874214280bb3731e5b26c22e1bd609c569f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "685cf1a3215e013cc8c7814c1791ec5fb35d7c8cb8e7dd0f168e97e56623c7f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe72098a32b731b4c1e3e286a2e8a9c9f682072407d8a7e6f31c5cd8b29a9a1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa720916519d81c9bffb99eb4b279a22899851077863c0e3aeb5cef1f7e69361"
    sha256 cellar: :any_skip_relocation, ventura:       "42d14996172b0a1b4791229ebe574d3a74a0433718d3992244f4876ba82eb38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a352732ef7b34cb869268fb9af159375800298daded83a6570348db7e92f05a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    test_file = testpath"test.md"
    test_file.write <<~MARKDOWN
      # Hello from Patat
      Slide 1
      ---
      Slide 2
    MARKDOWN
    output = shell_output("#{bin}patat --dump --force #{test_file}")
    assert_match "Hello from Patat", output

    assert_match version.to_s, shell_output("#{bin}patat --version")
  end
end