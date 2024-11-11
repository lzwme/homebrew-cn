class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https:launchpad.netmydumper"
  url "https:github.commydumpermydumperarchiverefstagsv0.16.9-1.tar.gz"
  sha256 "d06a5191bc77c0028eff0276edacc10696748423a86367866c66e7cb04e58af3"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(-\d+)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94e3a8acd033f4baa5c2e832f565ea6eea011b786271a7819d6c063f723d5440"
    sha256 cellar: :any,                 arm64_sonoma:  "73972263665ed855bb92637c540e253e4f3b0453a05ebc752003ad67ad914ba1"
    sha256 cellar: :any,                 arm64_ventura: "61a77b26a4b730387d4df40a785d9de032b464ff31df2cb7da6d4b45702f75d8"
    sha256 cellar: :any,                 sonoma:        "454227304a8c9a33634df7211ce06df8911c5d4e9a4256b034bbd7c9a0b77704"
    sha256 cellar: :any,                 ventura:       "2d02d7084ef8c92fb5e916d46cbef5c5ca1dd1a34d648d1174ef874067e648fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e30c0e641de67f8effdb85b9127721d2a1a087a99fcad74abe8ba78830ced5e8"
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