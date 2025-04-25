class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https:github.commydumpermydumper"
  url "https:github.commydumpermydumperarchiverefstagsv0.19.1-2.tar.gz"
  sha256 "16a64481d4379a4692ff2de44ebb251e5fcbceaf726d534a1f123b64f7eb6884"
  license "GPL-3.0-or-later"
  head "https:github.commydumpermydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(-\d+)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77c84d390bda2d243c8c404bbfe4b939c13f63fcced51958595235644d8be506"
    sha256 cellar: :any,                 arm64_sonoma:  "f474433db8f8fcfccfc452a3c2834b54b42f8decb5003f1e63928e0fd4be7921"
    sha256 cellar: :any,                 arm64_ventura: "29b81d3201a86c568848e0f8892a22cf27312573f15cadf89f4e9a17394a3242"
    sha256 cellar: :any,                 sonoma:        "be99cddaa520aa61f3361266eaebd9618587a0ae52d2d4a826474bed8c65221c"
    sha256 cellar: :any,                 ventura:       "0e28258abff16abe13e0b63269249f55e22274f6807dbc06f782a0c21f2b1289"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53d72ceb4716904c817233f77b09be00d63a268a78fe16ebe623ca7e61f2303c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea53f193a1f27df36798440d24976128ffa22ed8c45482d858a416f9f195f5c6"
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