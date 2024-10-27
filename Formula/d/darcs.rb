class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "https://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.18.4/darcs-2.18.4.tar.gz"
  sha256 "f4bc276f2f785c8f8c9bcf97288f124a4e907540140213fe47b1049e2d240338"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ab51d3124d6071463a5e68555cb466acc9411a8962450abf3ebdd23272a3a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16c95a9b58eb5f73267878a640c60efe5265aaebe46a5b50a088a6cc58771964"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1109f1290bde12f969e687acb3eeaecb167eb6ab53a88c2f2bcaa1e170243ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d72e2013f16f2b4c07b3f73bebc8576d412bd9d505ecc27f2a8d3d633ec7269"
    sha256 cellar: :any_skip_relocation, ventura:       "3fee618610376d14ced94634aa36472da02617369051d6e3e33de74a7b6f5f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84301f6b1449333210b9c3ae435e09f83e7967c5d33761c089186426c9d834de"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
  depends_on "gmp"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    mkdir "my_repo" do
      system bin/"darcs", "init"
      (Pathname.pwd/"foo").write "hello homebrew!"
      system bin/"darcs", "add", "foo"
      system bin/"darcs", "record", "-am", "add foo", "--author=homebrew"
    end
    system bin/"darcs", "get", "my_repo", "my_repo_clone"
    cd "my_repo_clone" do
      assert_match "hello homebrew!", (Pathname.pwd/"foo").read
    end
  end
end