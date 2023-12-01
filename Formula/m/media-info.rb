class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/23.11/MediaInfo_CLI_23.11_GNU_FromSource.tar.bz2"
  sha256 "34f54a4e51b532bd7d05bc597f19994878e17eedad3cb5a0ea1998359cb9e566"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "74112a384b3e55a24b5bca6687cb87497d1cfe1e5155f1002690a125c0d12a0d"
    sha256 cellar: :any,                 arm64_ventura:  "f3174c2fd526414511141c15b3c19e732a712a9c33b14c77417122c92e1b2cc5"
    sha256 cellar: :any,                 arm64_monterey: "697f1e57930ab43950c7274f396834ee0039905f957e4b335af665cdd2c4b8c7"
    sha256 cellar: :any,                 sonoma:         "fcf851294798d9a6bec8dd2c5ab9ef5a52326520292bc0d8120ddae60a5c5140"
    sha256 cellar: :any,                 ventura:        "c8e69c3aae2aa8f00a93904f7b64e174f232349fbe412746747ca63f5ffc33a2"
    sha256 cellar: :any,                 monterey:       "9884a32ae67f8131d0c6eebb4adb9add1c742af0ab0ef8a1ddc7662aeb9fece6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4756172743a57bcdd40ee9ea77df175e02cc0de8e6d8cf190bac5bc1b169b871"
  end

  depends_on "pkg-config" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  uses_from_macos "zlib"

  def install
    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end