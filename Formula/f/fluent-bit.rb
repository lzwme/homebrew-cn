class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "8ea5a49e960b8888280a84cc5d0e5f3b354ec8763c9759b4ebcd6ddba759a606"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "518bb1f2a550b02d1fa5739497c6710faa7077368eba0ff7e485e47432b921aa"
    sha256 cellar: :any,                 arm64_sequoia: "5d0c3a00f6ce6c31dbb87743d845556ee50d1f44cf0d3e5e0eb52af5d2ca9a95"
    sha256 cellar: :any,                 arm64_sonoma:  "edd69c7d3efdbe49e5e00cc7d9104a4066b407b223282df82f24ac1f40920603"
    sha256 cellar: :any,                 sonoma:        "dcb08ba94d036e048d136c4b93d8e56bf19a7152a99b98b1d2c5611b5b4c1176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0ec75758a43b211a1cc583311b54854fc839698b0b07997b837bf63f1eaa37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11698bde57feee923d382a8c62d5e1d14ccfb1c1854deeb1ead5ce48af597135"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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