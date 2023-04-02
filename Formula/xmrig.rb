class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://ghproxy.com/https://github.com/xmrig/xmrig/archive/v6.19.1.tar.gz"
  sha256 "7add542acd5e91099301ec1f8f4a5d41bd31bd4ba13bfa9e1144c1cd790cfc6a"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "82565b5aad965e0ac8e646e514f15b55c0d285d8194ce239c7c648df69af93fa"
    sha256 cellar: :any,                 arm64_monterey: "4d3cfbf91a46b8b5bfa47a4a8127aa8ef4b7568acf6aeb3be4c210aa016594b7"
    sha256 cellar: :any,                 arm64_big_sur:  "ea1b07b01af80431f5a5c7825f14977d9176e9f1177c9cedb4ebecb823358a79"
    sha256 cellar: :any,                 ventura:        "5b75150d00f020e613a06e6483b9806f5a611fc15844f9ce7b5d7804e387a470"
    sha256 cellar: :any,                 monterey:       "7e0a78586ba57b80c2f4376a5e05cff9763f202b9f81b60421ea1da246163389"
    sha256 cellar: :any,                 big_sur:        "916469965274a33521fc76174931d10c3305fa45f23b5dfe15a272e451b50d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e1e422be44ae5fb6c4dcc92ac47f1d252fd1fc84412c81a063f491b0e81fe9c"
  end

  depends_on "cmake" => :build
  depends_on "hwloc"
  depends_on "libuv"
  depends_on "openssl@3"

  def install
    # Use shared OpenSSL on macOS. In cmake/OpenSSL.cmake:
    # elseif (APPLE)
    #   set(OPENSSL_USE_STATIC_LIBS TRUE)
    # endif()
    inreplace "cmake/OpenSSL.cmake", "OPENSSL_USE_STATIC_LIBS TRUE", "OPENSSL_USE_STATIC_LIBS FALSE"

    # Allow using shared libuv. In cmake/FindUV.cmake:
    # find_library(UV_LIBRARY NAMES libuv.a uv libuv ...)
    inreplace "cmake/FindUV.cmake", "libuv.a", ""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/xmrig"
    pkgshare.install "src/config.json"
  end

  test do
    require "pty"
    assert_match version.to_s, shell_output("#{bin}/xmrig -V")
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
    PTY.spawn(bin/"xmrig", *args) do |r, _w, pid|
      sleep 5
      Process.kill("SIGINT", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match(/POOL #1\s+#{Regexp.escape(test_server)} algo auto/, output)

    if OS.mac?
      assert_match "#{test_server} DNS error: \"unknown node or service\"", output
    else
      assert_match "#{test_server} 127.0.0.1 connect error: \"connection refused\"", output
    end
  end
end