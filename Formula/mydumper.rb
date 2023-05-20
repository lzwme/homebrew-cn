class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://ghproxy.com/https://github.com/mydumper/mydumper/archive/v0.14.5-1.tar.gz"
  sha256 "d4ee18d60b7b3931009e906f927fd003437866e149baccf3063247b6d14a0894"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5abb9ebcedbe1840972d88741ad08840411f36e0677ae0145ea22d0adc49ad37"
    sha256 cellar: :any,                 arm64_monterey: "7189d898976f59f71fb5d49518a74bc9626f488f85dd7dd47f84c1b54e0883a1"
    sha256 cellar: :any,                 arm64_big_sur:  "73f51f80d35f1bb968077499354f3a5654bc6798d6276750270c04d350944173"
    sha256 cellar: :any,                 ventura:        "356aa9830317a06f5d2f8590d7d91fc701a31130396ca51b971acf42340a8c27"
    sha256 cellar: :any,                 monterey:       "c0dd81d72a349d8f19a95ea1851cdfa767ced282a9a90ae1dffa182fc909cad4"
    sha256 cellar: :any,                 big_sur:        "bb9c543f7d3af80f87b85a754c3133b47788660d90d0f4ce1b4dde51b15c5551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85675a008e2966fbd46836a5a00a0e7d644db12ec600aed955164dd366cf4e53"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = std_cmake_args + %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}
      -DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib/shared_library("libmysqlclient")}
    ]
    # find_package(ZLIB) has trouble on Big Sur since physical libz.dylib
    # doesn't exist on the filesystem.  Instead provide details ourselves:
    if OS.mac?
      args << "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1"
      args << "-DZLIB_INCLUDE_DIRS=/usr/include"
      args << "-DZLIB_LIBRARIES=-lz"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end