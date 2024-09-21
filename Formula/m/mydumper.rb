class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https:launchpad.netmydumper"
  url "https:github.commydumpermydumperarchiverefstagsv0.16.7-4.tar.gz"
  sha256 "21770d744bbb22d5293518a3e2b8321e3afdb03de144a26f19ebe4a357c0c952"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(-\d+)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbc5f031e7c065d72587d3b21a5870813a46616d138817ae086d0cbcec6db0d2"
    sha256 cellar: :any,                 arm64_sonoma:  "807ef28d6b27ee0f29ff3d43e34817dea0063865383568dcc3a1d93904b6c63b"
    sha256 cellar: :any,                 arm64_ventura: "31ac7d9a1ba66dccdb15268db5aa227e8fecd50a0467562d1db0a2b805b5f031"
    sha256 cellar: :any,                 sonoma:        "973628b522af33a243482ed57b939abaf2599841901c8d98c638fa62dfe8f093"
    sha256 cellar: :any,                 ventura:       "c73e7209e0a611b84ab8f773103229adc1b5fbddf54a5cc56971c96abe57de13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620de89584ae5573f42e824317a2d779620d5e9374ee260e124793e19df9c205"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "pcre"
  depends_on "zlib"

  fails_with gcc: "5"

  def install
    # Avoid installing config into etc
    inreplace "CMakeLists.txt", "etc", etc

    # Override location of mysql-client
    args = std_cmake_args + %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}
      -DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_libshared_library("libmysqlclient")}
    ]
    # find_package(ZLIB) has trouble on Big Sur since physical libz.dylib
    # doesn't exist on the filesystem.  Instead provide details ourselves:
    if OS.mac?
      args << "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1"
      args << "-DZLIB_INCLUDE_DIRS=usrinclude"
      args << "-DZLIB_LIBRARIES=-lz"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin"mydumper", "--help"
  end
end