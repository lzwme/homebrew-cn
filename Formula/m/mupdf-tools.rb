class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.25.1-source.tar.gz"
  sha256 "81aa1361252418cc45347b4ac075532096957a7ab772e20e046f3bb418d7263c"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0f7e1c0db25089ca7321645be71a26f7ad7e2571d243c0af592a59928e1f3d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b62e5a8d94342d02ce1d4b19f3862a9b47dee4092e4c34d572096e3f1493d1c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ddff17bf8fdfa7cce2851b13926d91777ba5532729cb4f44a7b139f878ea2ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "248b779f06e8e39befa4b4fd7d34e3cc2e6532764abdad010a33eadf684e4d11"
    sha256 cellar: :any_skip_relocation, ventura:       "1356f490220f56294504a80cb4e8cb8ec8bbef5b4af0fd80d3d29e4c337da83d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9391c4a58921ff9bf078c6f50c1f6d21bc9e207703cd442b83de9a1e4cdf648d"
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