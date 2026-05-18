class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://ghfast.top/https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.1-1.tar.gz"
  sha256 "742b89f3bc4d87dbb310647c8f9bba6a41c533800a11d30b798e1e4314ba4492"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "359a32be0af2674683becbfc06cb9351d0f5c1bc167e307a856a5218be11224d"
    sha256 cellar: :any,                 arm64_sequoia: "7c8b7a61a8d6acc48bbad9258cbbe23f1aa8fdcf122c021b9054d5369299356e"
    sha256 cellar: :any,                 arm64_sonoma:  "8e37060377da0431d3fceb123850559476bebb0957adbd7d824c83e62b80ba96"
    sha256 cellar: :any,                 sonoma:        "5c2dddf71d740820de9c352160f9b2886f006d5b3e857a26fe7d40bd253cad19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee8a883e046cef44b2448ae8fc54496a2aba4902b72d1fe5de1eaa76bd41ed0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9219bc5fae95f5ea4682da656f696d483788c0ca30fa28294729867d816bceed"
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
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

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
    system bin/"mydumper", "--help"
  end
end