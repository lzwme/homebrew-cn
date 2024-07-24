class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https:launchpad.netmydumper"
  url "https:github.commydumpermydumperarchiverefstagsv0.16.5-1.tar.gz"
  sha256 "02cf1034e64f1beb45c5a37b6fffb100b2d928d8dd37a31407a6f97c18d36181"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(-\d+)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5aed09623f292ffcaa4637199c972046824978cf153992c7d9517b89c2bd6a2d"
    sha256 cellar: :any,                 arm64_ventura:  "9b1b7a90144992791dd6b177089f4a9943f3fa20ff59b6edcc08b1006d74ae53"
    sha256 cellar: :any,                 arm64_monterey: "e0b736ace8c749bb2cfc414f5ecf788a5eecb3170b2cbbc4221e2725eb6453f8"
    sha256 cellar: :any,                 sonoma:         "5d0db6364e0485cb90e62907af2797c021b3b28b640360b4b2f5be579d595457"
    sha256 cellar: :any,                 ventura:        "7989140c43e698d05e55385f66ce658256cd05ee5c87f7d94c89f786bf31edff"
    sha256 cellar: :any,                 monterey:       "c19a58de2e8c465a223a0585ee2d479dbd0f9831eaa44919c56a59bd322db1d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edd2c8919985eea7c730240591c44f44bbb4afccc852220b5b69206f699d7451"
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