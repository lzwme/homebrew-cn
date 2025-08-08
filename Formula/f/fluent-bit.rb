class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v4.0.7.tar.gz"
  sha256 "cce8ba4f66cb8740e0078642eb9f41e4d25d1399dfbdc8f39c83dcf359380e92"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c7e2633e1152ffcbdedf78f593e6f2e8f3143fe0b37420e8f8d459ddd464e68e"
    sha256 cellar: :any,                 arm64_sonoma:  "e5008129f612090efc51d9c77d0dafd0aa4c9cecc5aa789aec03104d88635761"
    sha256 cellar: :any,                 arm64_ventura: "81aed23fefe7de5d0cf7ee02f01154e28aa53f82cb877587e08b95d638a464d7"
    sha256 cellar: :any,                 sonoma:        "7babbe77f7bd6b374158912251711edd2fdc0daefc6ee3c57cfa4d29ba1b9635"
    sha256 cellar: :any,                 ventura:       "d97760a1d8045d0d7d0187955ae7e6c112d4a3f688c99684fbdee7c1debedec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9914de9dc3d30d744ff56d616ce08b74337de43268d4b6eeff457a33fce1f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bf42b0ae690d43eb778910e307d515b8e4f7dd9b72bde3dd603fbdf2ff4f180"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end