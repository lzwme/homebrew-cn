class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.1-source.tar.gz"
  sha256 "dc94c60b2537e2ac9a2d379dd3801545f84a3a302d15c9da358362a1270707c3"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73967fbcff0300ef7a5d7ad08714845849d3a18ba9cb3ecca922daf8d8abe527"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7832b33da3edb6bbf998cad4c99a7b03c48bba9378dec39e275566af05b93012"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2e939f2ba09aed67157517f1e8c588a4425a0ef51799e8d14ac86a914daffc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f247a81f6c5a6e0aee2df55612d5b66dfee6096c56b4c792145770e35c01c7"
    sha256 cellar: :any,                 arm64_linux:   "f3b96be412032412152f3b01654de869fd50b7d9cb17eec80af943c1bcd4fd81"
    sha256 cellar: :any,                 x86_64_linux:  "57da6feb6abda4424711bac79c265652f9843d14a47f9959c44a1b7fd3c05c2e"
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