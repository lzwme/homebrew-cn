class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https:launchpad.netmydumper"
  url "https:github.commydumpermydumperarchiverefstagsv0.16.7-3.tar.gz"
  sha256 "ef6a331f78cdb037837c885bef6b8b1e944fcb8c510d69881f4e6879dfa882d9"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(-\d+)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87d82e116b47e38f4670763cc072d2d89e5ff4befe5cfd1ede4a4ef9e65d31a0"
    sha256 cellar: :any,                 arm64_sonoma:  "c9dcc40bb8793c6bf17edcd4537c8ba40c42c5c546b58361b7d26c9c3c54f19e"
    sha256 cellar: :any,                 arm64_ventura: "04e4d241f9d5aa42e7e93c0ebee612938ebaddb8e1f6f8526273ed1e575781d8"
    sha256 cellar: :any,                 sonoma:        "fee17d13281d1d9ddfae34a4f105a08532061b4f0ff2edf5c473013738faf3b0"
    sha256 cellar: :any,                 ventura:       "2a0d3ebb34f4e417c7c94d70b7aeae8cf91dd49b77f167c81555c0a456c9f1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9914ac0d0ed2cebeee1a534d5573a928663eda6a59703019431fdfb63ffde5fd"
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