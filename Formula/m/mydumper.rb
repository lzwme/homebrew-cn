class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https:launchpad.netmydumper"
  url "https:github.commydumpermydumperarchiverefstagsv0.16.3-6.tar.gz"
  sha256 "e9ec1d3a49dcd02297374ef0156b6ce480ee969cc61c1a4a4b81584d98994128"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(-\d+)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8898d52bbf283321f6bf790de8e517dc4c30889f2e11e478ec1ea9633c99baa2"
    sha256 cellar: :any,                 arm64_ventura:  "79705a61c97efaa44fad4b92f18b8b8991d289670ab5f7e7ae0b2e6eb11dd15f"
    sha256 cellar: :any,                 arm64_monterey: "0cb3f410f04390c4cae7b0b60cbf7d6d5735bcade01b1add1553abab822b5753"
    sha256 cellar: :any,                 sonoma:         "df9c4fec05879c8214dd2f451751f595b0f04a1a8768b99af319b4dda240cf2f"
    sha256 cellar: :any,                 ventura:        "130db242a01380bf111994239f768f62996362cf9363d9e1473d726249851605"
    sha256 cellar: :any,                 monterey:       "00ebb943288a6c82774a7f202223e56e9c89be407be210a15c1b5621ee72e688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a545dcacbc98cf7603ac428269192c89d7c6f77c80924c23e9518b25e8a2c93"
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