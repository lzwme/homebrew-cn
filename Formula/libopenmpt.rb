class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.0+release.autotools.tar.gz"
  version "0.7.0"
  sha256 "411796b55aef73cab09c7a6e65d33f1d7bf4ee7fc2dade6bc8de5138dedcc6d1"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "85da01c4cb51a5c182b9ea1fe5880d65c490fa586606c2662de51dfe95737b20"
    sha256 cellar: :any,                 arm64_monterey: "db3a3972a68c2c2bcd606621f5e19575fa1ee25ca6c6e750af89ca1f4d4ff7fb"
    sha256 cellar: :any,                 arm64_big_sur:  "d40eccfcb2bf9c88eb2c46a5f54a089631126be1d079098f1daebc66d12233c1"
    sha256 cellar: :any,                 ventura:        "0ca44a3b9220f489e4442910f2b4791ab41c379afcdea60d408130c18fa6705b"
    sha256 cellar: :any,                 monterey:       "58c2a59f344526c303a6360ed6282aa6cfc5442dff71aae4f5ccef9dc0be726d"
    sha256 cellar: :any,                 big_sur:        "25ce8b805942a06bba20844e8101cd398acf0507081bfaff2fc34d0d37aeee21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be64386f6a89e35f4448228a3a98fff4670310e5595b0017e78d825d5dae7d28"
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
  end

  fails_with gcc: "5" # needs C++17

  resource "homebrew-mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-vorbisfile"
    system "make"
    system "make", "install"
  end

  test do
    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end