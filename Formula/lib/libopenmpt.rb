class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.7+release.autotools.tar.gz"
  version "0.7.7"
  sha256 "58c6a28972126828a6f658e084aee7aa8f8bfdb75a0bd0e345c7ff2a6d9ef08c"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f5a27dadccbdda77dc43e6efce4265c9f6f2e4afd18e5d7c1489ec25f4c1deab"
    sha256 cellar: :any,                 arm64_ventura:  "facd4882b492d14d05594a1f3afe391671ced099a0669556278458112e62454c"
    sha256 cellar: :any,                 arm64_monterey: "fce8c8bcc2be3299216f0e859de1604e54ab19608bb3675dddba0a9ab402086a"
    sha256 cellar: :any,                 sonoma:         "1fcbba0710ea623b60efb6ac18f6ce8a30b025cad9e35382c5d6da8dffe59574"
    sha256 cellar: :any,                 ventura:        "4d77b3d3409a2f1b3d29b9570e284da389ea6f8fe8671c166b615c5e3033feb0"
    sha256 cellar: :any,                 monterey:       "5acf3f4f22b34312ae5b2aeeac6664b8d15f8e2c07cb943c45dba6960f23a3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa27accffb34e1cdba9867d5ac2bdb966ea90d5d84326e242b5b46e7e52016f8"
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