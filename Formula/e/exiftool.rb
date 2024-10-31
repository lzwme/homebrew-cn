class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-13.00.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-13.00.tar.gz"
  sha256 "4895788f34f834765f86be4a5ad5a32433f572d757160ecd7b612eaf5ed37e84"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dd93d1ee330d6e80652335324ecff3def7375576499029d9f45a50fb3674401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dd93d1ee330d6e80652335324ecff3def7375576499029d9f45a50fb3674401"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "243e83a5a3e0d0d626de64f16be6ffda298284d896c387d58de9a8bad446d3df"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2ee4af7fbb303d71fc9f3efcf7632211569cd33a1380a29e7c192c7e05ae0f9"
    sha256 cellar: :any_skip_relocation, ventura:       "383b2984c26a407ae0150135ab2554d7108e087446110d5f6a71115282076fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66575c9dc024fd821062acbbe4ef84c44da30a9f97d88e1bd2b439b76ce269b7"
  end

  uses_from_macos "perl"

  def install
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