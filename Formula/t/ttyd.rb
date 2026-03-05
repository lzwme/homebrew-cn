class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://ghfast.top/https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 7
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "9458d1ddda59954c46fd6b49724d3f0828cd8e7741b73fe3a270d84f9c6c7e54"
    sha256 arm64_sequoia: "7a573f076a8fa05d73464dfe1a31a454a36d19948b5d9ade3b46069d4fa20d12"
    sha256 arm64_sonoma:  "fcef6186b5e2a8ecc9d2d24a0ab023a6bb27e9f03e782f9b144d25703f2f54b5"
    sha256 sonoma:        "fe3f5ca7fd1cd30d996605798c6f9ccb775a52438ccf173a1237d6a5ee7b0988"
    sha256 arm64_linux:   "ed86bbe8faca4f5f7e1b2ffda6432360806af7e62f107cbcc6c91a19a574778f"
    sha256 x86_64_linux:  "754aa0b7612887c71931b66b337d22192fa32f3d3d700abe39355b258ae20e10"
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