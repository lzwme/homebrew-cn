class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.6-source.tar.gz"
  sha256 "ac11eb859dd404488e5153cdc9651bb4341e5baaf4d3b3f27e2afc82f9aadc29"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7629c10b70006609d8fe9344dad4b2d3e41aa0683090bf9b1510dbdd7b6063b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "620284e379e899190616c0b95b4ac5e9212154e841d32da1a49c7f7c8371834e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c3bcd7224824ec3c7843f2be1b8b86b5e075792905dd53b03df790ab0332de6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6422363ff46a8dcc41b73aee75ea8882e17ccaca5ab1641d66b5e489f7fe5d5b"
    sha256 cellar: :any_skip_relocation, ventura:        "45a4938ab1bcaf34f914c6be5df81eed992042eb0ef7a12cbf81ce408a9b7d42"
    sha256 cellar: :any_skip_relocation, monterey:       "e27dc0be5c04648af9a4b25dbb0bf6addde8bb36e343bc1a1e1fb6907a419c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd7252461c620ec10443f746e37c1f59073381995fcd41bb1f9ccb66100a4901"
  end

  conflicts_with "mupdf",
    because: "mupdf and mupdf-tools install the same binaries"

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