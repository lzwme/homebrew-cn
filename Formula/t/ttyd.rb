class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://ghfast.top/https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 8
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "4ba588d78a1d3766248e1442db108477c3351ca8a7afae101ea68b1518a62a15"
    sha256 arm64_sequoia: "db754de2302d0cbc84ad7f53fe1420de2cf97b2ed2651861f2bd32d1453369c6"
    sha256 arm64_sonoma:  "ede2b07fa5ea636df9739978929cd7e004446024f3b28156b5e53af9c3ecd0fc"
    sha256 sonoma:        "377d9fab121e18e4a92ec95b7fb625cd96d00e9dfa61698ce4b9ff4c7e4adc37"
    sha256 arm64_linux:   "c4152dff96aed5cb76ca0a2b5a9aadd1281445165039f44de462188204a7f5df"
    sha256 x86_64_linux:  "339e9e8741a339589cb8af7d7cf391881a459691b6d1505e457c3e96f46f2586"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-Dlibwebsockets_DIR=#{Formula["libwebsockets"].opt_lib}/cmake/libwebsockets",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    fork do
      system bin/"ttyd", "--port", port.to_s, "bash"
    end
    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}")
    assert_match "<title>ttyd - Terminal</title>", output[..256]
  end
end