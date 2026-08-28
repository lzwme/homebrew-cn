class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.3-source.tar.gz"
  sha256 "37c3209dc0e06fa4f3781ed44839ad933a9e6143eb4731f99e069204715bcef2"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c83f81e058928fae31807319f2a28580ea43eccfb303bf0aa2b4caf836da37f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a585805bbd33563c3b95886e4beccb817e45a554ff353d5ae721ca93c74d69b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42d1dd33c832b15a56f414ddc508b4821f93a8111b73f0c8e1ea4b9c1821013d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfc51e17e4d46ef79369c43d6a30b99322b61e7a8bad07d8b932dd5830e860c0"
    sha256 cellar: :any,                 arm64_linux:   "9dcaa51f5aeb5e41d6e045fd16c9b47a725820eff6eb06cfc4c91330b4c079fd"
    sha256 cellar: :any,                 x86_64_linux:  "6324c4a03108274a79d97d88a2bb0f103adc51f1dddd0648250472f225d6df15"
  end

  conflicts_with "mupdf", because: "mupdf and mupdf-tools install the same binaries"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end