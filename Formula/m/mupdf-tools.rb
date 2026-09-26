class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.5-source.tar.gz"
  sha256 "98a5c10cda20c3992cdf76ff6b2a1149c32bd79cc796d3f703230b1185b7e934"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9d12d4b8ea057012c4a8319df2db6f0076cbf19042cc4ac9de43079f2a1e70b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f28237538ff6a8c4fab9d3e3f3fd302aa25b8629ecd1f0d327c35df82191c829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d36f91531459dfc0eb02220cccad03ca6346c58bbd6e46f7d66a45160df0137"
    sha256 cellar: :any,                 arm64_linux:       "b1fe65f2e5655519ec247038f68c534979940cf08964cb73d7086a544d147862"
    sha256 cellar: :any,                 x86_64_linux:      "5e670af508174bdfc21850abed734390f0e4afb2ddae1c8d554299b8d13454ae"
  end

  conflicts_with "mupdf", because: "mupdf and mupdf-tools install the same binaries"

  deny_network_access!

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