class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.25.5-source.tar.gz"
  sha256 "1fe78c0667f176459bbd52a576ac4a7a2d2c9f633382c3d2a3e07e8659e6c1e4"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bca7dc35d5d9afd0daa8669e40ecfa71b50257c8df8fd432fae13c5285e522e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12786aa011120324e1d82e602a22fa3422a4a4f0f25a7584d7c12c698f75ea1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34686dbd12778e3804347dab0bffed5d882351e09d67a3297200abad5250bccc"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa34bc74fa3c14b991713e9c678cc11a07ae4c0afaf664975782e84898aa4c9c"
    sha256 cellar: :any_skip_relocation, ventura:       "bd4ea1988b6a98e68b42c4f0182b94a77ca00701f13ba1ddace6b79a156861e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4975a6fa0195e538b6abfdcc1a2ab346470f21fa628285ec3e9988539f572b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54968cb1053409f7c5e54a53053932d0fcc6f1c880085b55d5a342d74d067da7"
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