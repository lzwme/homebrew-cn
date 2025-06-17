class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https:github.comxmrigxmrig"
  url "https:github.comxmrigxmrigarchiverefstagsv6.23.0.tar.gz"
  sha256 "3cced1a97cc2646956c7185932c59253b621603f99c64fc68c4a35c8247815f8"
  license "GPL-3.0-or-later"
  head "https:github.comxmrigxmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7aebcfb6cadf35ffe4eac92bffbfccedce5d67b5edb2c03d11dc8a8e19e7510a"
    sha256 cellar: :any,                 arm64_sonoma:  "40a24c42e809a8763a08da603a8aa6fdbc0e97dbac1ecd278ddbd7c790a92aaf"
    sha256 cellar: :any,                 arm64_ventura: "81bf509f30ba8e1d0d50920d25c8c32b384ab9b7d0c3fcd7eefa04aed1759023"
    sha256 cellar: :any,                 sonoma:        "f5013280fc516570dd3ac1eba3179df6adaa1addce30157f5510f8d1a7520ad5"
    sha256 cellar: :any,                 ventura:       "360b222904234396f2e6507e5fe6c1d7626e7232b84f09fd62c6343c8ce07f34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e8ad8887418e33e2afb5460bfc3ab616b8428c6997565727168a9a11558697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f64e36541bd88460a922920ab032240082d89ed8512a9f3799bd9f288545dffc"
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