class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.2-source.tar.gz"
  sha256 "2a5e1fc84f67bc593ba1d4d9d49f8782e8b12241e2eec904a65a25e4322c72a9"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f6344a3ff4e21f86d818266507cfbb1f0cad8cc5b139fc6bf0754f430909ed8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a8f73df20fcaa0af896a332c5b8a4e36d821e934e4ef67709a775b67a744eac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "443ed3752a690fcaf78170c0037652d1b59340efc233e7a171242187debd26a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "65da7678f2c557a170eb4e37e4bda9e880ed4e3fe9efaa01c6f37bbb5b8128de"
    sha256 cellar: :any_skip_relocation, ventura:       "3f4350843e2cf423142e2662ca64d0ce56055f7170239016bb852e16a07da1e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "642cca9305333c6ab98961223fec56fb77f661ea95734d12bb974699589255cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b75588ab62bfd8ded6bb0f5a6f9092d1858bafde91a3acee4ff6ca55b34a54e"
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