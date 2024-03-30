class MediaInfo < Formula
  desc "Unified display of technical and tag data for audiovideo"
  homepage "https:mediaarea.net"
  url "https:mediaarea.netdownloadbinarymediainfo24.03MediaInfo_CLI_24.03_GNU_FromSource.tar.bz2"
  sha256 "2ac3af072a73a96fddc5bdc7d371ae73a72feb510d1654393e68c5abe7b8b3ed"
  license "BSD-2-Clause"
  head "https:github.comMediaAreaMediaInfo.git", branch: "master"

  livecheck do
    url "https:mediaarea.netenMediaInfoDownloadSource"
    regex(href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e7d12dac1106f1de3ee1abebdf83479ddb31908c5ade243e679564eeb4a58b31"
    sha256 cellar: :any,                 arm64_ventura:  "854bd8255b58b75aef68a62fc5286b7ba445a69f4cb0e48c355a77c50451142e"
    sha256 cellar: :any,                 arm64_monterey: "ca35193667af7a6e8d536f0143bb7dc42fef1118f0477cb959a98c1872a6f15f"
    sha256 cellar: :any,                 sonoma:         "35255ca7d89126cc940686ec650a0d7fc8cb6e9e4b0a13706b0efb841ad8dd72"
    sha256 cellar: :any,                 ventura:        "e7d7184747a40b168c801aa56e96448afc6737006ba9e87950d124b0a302c13d"
    sha256 cellar: :any,                 monterey:       "4131e0b16eed993367370ab24d744d52833d5e2274571e83ad54ff35d2a258d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdb0bfa46053d40e929f20aad7beb1464e5e5136d13d5c6974c2343136b438e7"
  end

  depends_on "pkg-config" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  uses_from_macos "zlib"

  def install
    cd "MediaInfoProjectGNUCLI" do
      system ".configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}mediainfo", test_fixtures("test.mp3"))
  end
end