class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.0-source.tar.gz"
  sha256 "d896f89eabfc5aaaabcdddc30f4592f6df33075640759292dd338d8e69e59c63"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8df3f6ebbf2c50eb2c02ff622a745948223df1fffe515fe0a0e4838bc509c9b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c85d08c24c772344bed0b7f5e99e7088c18b914018cb8e4e113b32411201a0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "758971a3bc4791263721b3d84285a032949d8e59b8b89521ed29c47fd694b460"
    sha256 cellar: :any_skip_relocation, sonoma:        "28618ba854f25915520ed4c9c61666da7da57484509a177d7d35a89ada4ae50b"
    sha256 cellar: :any_skip_relocation, ventura:       "154f0dab73d3dabbfd5fa55f536e0917e39567c934c98968e3d24583637a7797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c66948ee6d0210fe61cbcd82268dc87ad2656f3585917e143bb58e57d6f62922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0902c56662a2551e00bb2493052c09e6c1745d1db1f8bcbe0db0662e09f51e13"
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