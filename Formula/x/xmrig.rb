class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://ghproxy.com/https://github.com/xmrig/xmrig/archive/refs/tags/v6.21.0.tar.gz"
  sha256 "4b197c71fa06030216b641b4ea57f7a3d977a17df1b55bd13759d4705dbf5941"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a9684bf6686239161f986cd8fe1f5e5ba67750ee8416678f2fff70018af0dab"
    sha256 cellar: :any,                 arm64_ventura:  "6d29e5f467350af4ef4e844cf76c43de1c803a9829be1f96489bdd37fd639ba9"
    sha256 cellar: :any,                 arm64_monterey: "a8d8f679ecce0d5bd35cef12457c8764a053642b4565fb6fa198cedfba9148eb"
    sha256 cellar: :any,                 sonoma:         "15f778027a76a1ec6f34e1f2210262c1dd3bb2e8d28016ac5892514ed7187abe"
    sha256 cellar: :any,                 ventura:        "6a368395a7cd732223bae095f6a71da714934c45580bb5703a37135ec349661b"
    sha256 cellar: :any,                 monterey:       "f362548a34b3b9211873c6fd23622cf8e16bfdfa72468e25f895a0f2106d4939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e0db907067d978b9aba52ce5db74850abedd3f0b38de42f7dc164a44f930747"
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