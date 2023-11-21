class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-12.70.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-12.70.tar.gz"
  sha256 "4cb2522445cc3e3f3bd13904c6aeaeada5fc5a5e2498d7abad2957dcb42caffe"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06999b5ba8f63ddf6c89d8e411bb43d0efc4c354d0e6402feede7b4aaa800f0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "862bd853237dcc82585f79649e66c06194fcea90793eec0b9243b20b7236eae4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "862bd853237dcc82585f79649e66c06194fcea90793eec0b9243b20b7236eae4"
    sha256 cellar: :any_skip_relocation, sonoma:         "60a7df2ec24a8fd7e10291f369cdf7a569e14587fbcea759dc9e40b46214c279"
    sha256 cellar: :any_skip_relocation, ventura:        "4ae13f4922fea01cf68d7c88b81811db0e22f0d8a43c7ec55424096d77b2ce94"
    sha256 cellar: :any_skip_relocation, monterey:       "4ae13f4922fea01cf68d7c88b81811db0e22f0d8a43c7ec55424096d77b2ce94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17f75702df68f918106de1d3ca08726e306a627f98c015dd3f9f34aa0e5b87fd"
  end

  uses_from_macos "perl"

  def install
    # Enable large file support
    # https://exiftool.org/forum/index.php?topic=3916.msg18182#msg18182
    inreplace "lib/Image/ExifTool.pm", "'LargeFileSupport', undef", "'LargeFileSupport', 1"

    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "unshift @INC, $incDir;", "unshift @INC, \"#{libexec}/lib\";"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    man1.install "blib/man1/exiftool.1"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end