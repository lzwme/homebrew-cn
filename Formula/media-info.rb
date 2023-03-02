class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/22.12/MediaInfo_CLI_22.12_GNU_FromSource.tar.bz2"
  sha256 "4d3a644e35244343235be938b29c9fee71e2ee3887dd7cc67f91ee15918536a2"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "61c281c738f13c73bad9458efb84dd91771706ee65c9d84828d09fd5e7ec463d"
    sha256 cellar: :any,                 arm64_monterey: "2f8b05e4974b67f49903b1bb17fc34f0491823fb5b1ae24a4efc89443712f3d1"
    sha256 cellar: :any,                 arm64_big_sur:  "149d52775924c650d45d61fab27bae6705ec0fbbeaff426029c256b39538cfef"
    sha256 cellar: :any,                 ventura:        "e6f01f02a711dd1ccc45d51d3757098024680a60d4315fba0263b6118fe29bcc"
    sha256 cellar: :any,                 monterey:       "aec450e24ff0ec5ef010738e92c76dad4f249208aa29c45faae6821390b998d3"
    sha256 cellar: :any,                 big_sur:        "5d32cd688703465beaeccc29f0afbefbd218cfd418e9d9ba1230710179ebda6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85c942dc97bb60c1867093010429b88c24809e8ef667782a0821bc0f480066a8"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end