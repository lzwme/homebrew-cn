class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https:launchpad.netmydumper"
  url "https:github.commydumpermydumperarchiverefstagsv0.16.3-2.tar.gz"
  sha256 "6a3265cf7f168ec435a37ee5a06dafff6008d62af0ac6d1dec1e401247761c53"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(-\d+)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5265c8555ee8c46b9c1c8b896fc8b1eee9be3dc671f651b9d7c58457714c2dfe"
    sha256 cellar: :any,                 arm64_ventura:  "17dd9f5c57c7090eca7e0b6d4f3a840c70eb871e8a5084901d1fb15c4636ad2b"
    sha256 cellar: :any,                 arm64_monterey: "7318932f83f6757ad7815d028403346588eea308396e7e1fafc2a9b7a0a29994"
    sha256 cellar: :any,                 sonoma:         "d794e9a47d9bea354f6638689467efce193f0b3f365174ca7e58bf6ce9a6c8ad"
    sha256 cellar: :any,                 ventura:        "9a4ce3b06fd101a8c2f33981935832d17f7c9cadd37e599695c2f31f32963907"
    sha256 cellar: :any,                 monterey:       "3681b8980f9ae3c29096754f2aa60b2678b94319d7b7b24eb48471be8ce84df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a5429c4d750204fab241827a4eee28f12f7ba03e39bbd6026c6fe3b8ea3c8be"
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