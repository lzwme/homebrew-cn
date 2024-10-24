class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https:github.comxmrigxmrig"
  url "https:github.comxmrigxmrigarchiverefstagsv6.22.1.tar.gz"
  sha256 "189e4bf604f8b569cd15894439a4ad0209b64184c8ccb5a2119a4f07c16da448"
  license "GPL-3.0-or-later"
  head "https:github.comxmrigxmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b5209270265a2dc9c75d129c5257e2390a43b72d94581b8d883599379c29d2d"
    sha256 cellar: :any,                 arm64_sonoma:  "03330685b132cdf87cd09bf5fe174834ab0747bb3fe55474fd1e6a0074184741"
    sha256 cellar: :any,                 arm64_ventura: "5a8990b043d15b5b1d6fa500bec5c2d6656ee5913a29958021170569804b3bd2"
    sha256 cellar: :any,                 sonoma:        "35ca6fbee526e0f06aa030b7b4ab4c9f153331d8996ea4af2fc72ff4991ce2d1"
    sha256 cellar: :any,                 ventura:       "312b72571c176715cbe1d5f8b8022492672ebde2897a64e1b4d76738386c1868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cb71adf40935494f0205264d5f7ce5bb7d767f7758e1d87bcdff90f073ba955"
  end

  depends_on "cmake" => :build
  depends_on "hwloc"
  depends_on "libuv"
  depends_on "openssl@3"

  def install
    # Use shared OpenSSL on macOS. In cmakeOpenSSL.cmake:
    # elseif (APPLE)
    #   set(OPENSSL_USE_STATIC_LIBS TRUE)
    # endif()
    inreplace "cmakeOpenSSL.cmake", "OPENSSL_USE_STATIC_LIBS TRUE", "OPENSSL_USE_STATIC_LIBS FALSE"

    # Allow using shared libuv. In cmakeFindUV.cmake:
    # find_library(UV_LIBRARY NAMES libuv.a uv libuv ...)
    inreplace "cmakeFindUV.cmake", "libuv.a", ""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "buildxmrig"
    pkgshare.install "srcconfig.json"
  end

  test do
    require "pty"
    assert_match version.to_s, shell_output("#{bin}xmrig -V")
    test_server = "donotexist.localhost:65535"
    output = ""
    args = %W[
      --no-color
      --max-cpu-usage=1
      --print-time=1
      --threads=1
      --retries=1
      --url=#{test_server}
    ]
    PTY.spawn(bin"xmrig", *args) do |r, _w, pid|
      sleep 5
      Process.kill("SIGINT", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end

    assert_match(POOL #1\s+#{Regexp.escape(test_server)} algo auto, output)

    if OS.mac?
      assert_match "#{test_server} DNS error: \"unknown node or service\"", output
    else
      assert_match "#{test_server} 127.0.0.1 connect error: \"connection refused\"", output
    end
  end
end