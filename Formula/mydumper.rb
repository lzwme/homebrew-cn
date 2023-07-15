class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://ghproxy.com/https://github.com/mydumper/mydumper/archive/v0.14.5-3.tar.gz"
  sha256 "5eff8fac10551db7e43592e13397d089d014a926ec910151501ccf79ddba0c71"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97b51d7bca1bb7cc708145717168f4b0406d2ae7786484ef7af298f20dc2f601"
    sha256 cellar: :any,                 arm64_monterey: "ebc2e738e0046f32afd0241264cf8b48fc09c9c337d9153c6ee4ed6aa05b98e1"
    sha256 cellar: :any,                 arm64_big_sur:  "b378ed7321ab1a9c0db629a5a9fe9706126ec5240dc7c9bcb5369a72a3535fe4"
    sha256 cellar: :any,                 ventura:        "712afa53b476cb38dd639eb96f52bd369e2ef85304a97bac92db8cbb0fa12302"
    sha256 cellar: :any,                 monterey:       "48715dd688bc4fee4a2eff8305216205161acdb44674322ca26db92ac2a255e8"
    sha256 cellar: :any,                 big_sur:        "a793174466eecfde25061b74ce8b067674f6386f1992883afd4aa98bca95eb2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "673d8ad862938e56343a51e6f29ac531d12ac38cfe7734817460746e836c4849"
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