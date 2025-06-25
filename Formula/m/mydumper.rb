class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https:github.commydumpermydumper"
  url "https:github.commydumpermydumperarchiverefstagsv0.19.3-2.tar.gz"
  sha256 "8db52befb7cca70fdad19376dc8abd3589d112bdbc8fb824fc0fb2f3ce087424"
  license "GPL-3.0-or-later"
  head "https:github.commydumpermydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(-\d+)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2523e308f56cb3c6559c06fd8bf8f59bb695c3534eeb5bb9a3a5a3fcaf3907d0"
    sha256 cellar: :any,                 arm64_sonoma:  "b6c3ac47efa7db272908cb2260186f957cda354f6f41bf1726e9bcd851810c3a"
    sha256 cellar: :any,                 arm64_ventura: "0e37c1c270102fa76145310eb5452c0180171c0681c2e74a0d45850c352465db"
    sha256 cellar: :any,                 sonoma:        "d78423ecda9cdab523bbc7699af19ea33739a184e1f2bc8979df2d499926e963"
    sha256 cellar: :any,                 ventura:       "0a353a78aa665cc49deadcb56a32b7444a27134720fc94f59813959d214a568d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "729f759435df2552e44a8fdf2be79fd5a8b8d6839049b3401a3644bd9260d7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f77c28472a9b2971cc5dc7fa5a5d16134762599931b3097d806ae8bfcbeec2aa"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mariadb-connector-c"
  depends_on "pcre2"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    # Avoid installing config into etc
    inreplace "CMakeLists.txt", "etc", etc

    # Override location of mysql-client
    args = %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mariadb-connector-c"].opt_bin}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"mydumper", "--help"
  end
end