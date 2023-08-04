class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://ghproxy.com/https://github.com/mydumper/mydumper/archive/v0.15.1-3.tar.gz"
  sha256 "a25bcb283b2eab192640da2e55ab7798d92293693bb717fb1490d59bc35887ee"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbad47173fa2fdf95cfae278f4b3af51cb8826ab481308d41b32454d113c961d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e4fa145046b9c2b7832e52d5e9144e4dd15ce394bc37b40f0e601d75de0311a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11e62bdcc5f651dbd38d6624252727c777ea6061ced0f0e572e4cf1da24af31d"
    sha256 cellar: :any_skip_relocation, ventura:        "d896af996671b1faefda2ff4d5b9fa483ff8df42830098a96daad3a473281f88"
    sha256 cellar: :any_skip_relocation, monterey:       "2fba54bfeff1fb4c77d806b549bedbbb26b3ce3c3daf7e3fda87f6e9b30e06a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2db4ec2ac371fd9a4acd0618594b10be5734ce8a36ddd9aa25688ba538a56e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "265cf07936a2472f3d6f83f54c9d92b579075c57663f13fda43027e2f4457011"
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