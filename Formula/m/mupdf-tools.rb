class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.9-source.tar.gz"
  sha256 "d4a5d66801d85f97d76da978b155f66a5659d1131070c0400f076883f604e297"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c67366bfddc37d2e2a6debab9b9205bdbe6b8bf5660f946e30ce6258af4ec3cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8693578e6f2f942aed6c853eaf82d9ff0c256f2c21ddab4b6dcfbf71e9149707"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa2c93758bd3673268b6c210b126bc039a2874526cfd644ac9f7c8e1b7890c98"
    sha256 cellar: :any_skip_relocation, sonoma:         "69a293ab759c9119dafec4f976d59e529c0f3eb59e17cf4d88e539ca2e187c3a"
    sha256 cellar: :any_skip_relocation, ventura:        "b2b6d0ec916b9c29b2a4600824572abe902edf31d445dee12b5e5f8d1047f507"
    sha256 cellar: :any_skip_relocation, monterey:       "2e7c3421379230f2c4f8a946277be72f6bf338930ed13be31461b5932d2be81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5116008ff8d9cd5d045aba00936b69eeb8c8327df8624123b98c9149c48cfd5b"
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