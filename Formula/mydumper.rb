class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://ghproxy.com/https://github.com/mydumper/mydumper/archive/v0.15.1-1.tar.gz"
  sha256 "cb21aa491908c1a213796f757c821b7787b830e79313ef23e4baf58703f3c96e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75b3f387c522a910c34c68de44008d9b60b6195af85d1d0c698e2282e2d1f332"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "599e008264060a630bd5104c91ebd95ffdaf5187d66701cf920741dc7e9d57e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "190087f1bac2c83852a29f47fc5bd7fb0c5b4e97fabad176e5f8ddfbde7d8fe1"
    sha256 cellar: :any_skip_relocation, ventura:        "905e1e793ce44c8924c13edeec58dd28c75f8002ecfbd879e2afb3c0755bdc82"
    sha256 cellar: :any_skip_relocation, monterey:       "ee08f53296280d1254845f3f6b55974ad44eb4d9ba8f214654ee8ae3351228dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f42d404cd0dcb7342a988023aa673f8cb725f85784891219f8c20ab35a47ca66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "491ae89ec4fbd94066935fb975720aa98fed2846b22c689b2409620aa8950674"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
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