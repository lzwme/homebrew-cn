class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https:launchpad.netmydumper"
  url "https:github.commydumpermydumperarchiverefstagsv0.16.11-2.tar.gz"
  sha256 "19ff7c07ef29bee1808e753465344209e256d8a7fcd10854cab25761520f342e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(-\d+)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4cccf51f247418b3c67640dc04a5edb001ca28210ed8eb201c87126178fa3e82"
    sha256 cellar: :any,                 arm64_sonoma:  "b2a4f6f736cbc718e4cfd4cacc5ab48ab3e14cc04b9b453d07d9f7721db2a540"
    sha256 cellar: :any,                 arm64_ventura: "52430f857927f9a4ddb6dde2e5dfd9722eb9ef1492c54bfc40c6eefbe1737526"
    sha256 cellar: :any,                 sonoma:        "f59d5459657067755491560bca72a8d1e76494de870ceb3aa16a0a301fdde2a2"
    sha256 cellar: :any,                 ventura:       "99d40c95e2308810fc088056f8cd72e5d3cea25c63f804b1fccb464e6f79ad72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec90b92bbb9661217b670572d7ec32b72cfa1e3fd31eace7679bf57c96bc7cee"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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