class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https:github.comxmrigxmrig"
  url "https:github.comxmrigxmrigarchiverefstagsv6.22.3.tar.gz"
  sha256 "79bf51c11ad3670b8330ca1432c9cdaf84f82b96f94b636e33d253be2b916d20"
  license "GPL-3.0-or-later"
  head "https:github.comxmrigxmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7e8e14e3c1577daa9de513b955d588bdc59af63c034c0be1a3cf77631ca9991"
    sha256 cellar: :any,                 arm64_sonoma:  "6c0db3baaec85fe3c89794236299c9292cfbac00427cf663510749937b91a213"
    sha256 cellar: :any,                 arm64_ventura: "83959682fc5cb01b1e707b532454fea020f5244630ef43b84104ec0c4fdbc377"
    sha256 cellar: :any,                 sonoma:        "f1252db2b56cda7eb054e1dadc38bd645807b163db2e76e456c9c6ab52150ae5"
    sha256 cellar: :any,                 ventura:       "ef6bf16ce76503d54cb3629e93cc7138888121d91e207871de124cb79caf9422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6ab9049c13e556cd0377337bd0fe48f4f4ca6608c46535e28e631114e7d904e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bccfcba97b9f29f987dd25dbaec8db700309ba7924401c246f2c53a8064cb55"
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