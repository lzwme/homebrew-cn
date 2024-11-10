class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https:launchpad.netmydumper"
  url "https:github.commydumpermydumperarchiverefstagsv0.16.7-5.tar.gz"
  sha256 "f554552fe96c40a47b82018eb067168bcb267a96fd288ddf8523c9e472340f2e"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(-\d+)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d8fc984067f40b58b08b26d1685fab2971ad404f0c7251a1a1ecbb39ccd04296"
    sha256 cellar: :any,                 arm64_sonoma:  "2388ba98bceb1303aac9a61a24fa3421ac3001a9a610aad98c0254a0aa4d7df2"
    sha256 cellar: :any,                 arm64_ventura: "60ee0332942caa023e9dd902383e3ca21727f8488e808ecd9a53dff1ebcf64e2"
    sha256 cellar: :any,                 sonoma:        "16111e125f84e7341eb87560d4b0df5fbfdd6d1ab35985b18047efc9a3da77b6"
    sha256 cellar: :any,                 ventura:       "9ee2fb368c8a8af30bb4f526679c781e3dfbeabe353ab2e3d04f50733abf296e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad9993fd5845745dcd508cd58cc81d2746e829f3b3a9b83ef09ab5a8137f9c23"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mariadb-connector-c"
  depends_on "pcre"

  def install
    # Avoid installing config into etc
    inreplace "CMakeLists.txt", "etc", etc

    # Override location of mysql-client
    args = ["-DMYSQL_CONFIG_PREFER_PATH=#{Formula["mariadb-connector-c"].opt_bin}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"mydumper", "--help"
  end
end