class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https:tsl0922.github.iottyd"
  url "https:github.comtsl0922ttydarchiverefstags1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 1
  head "https:github.comtsl0922ttyd.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "f93cf800e7fd1d481039bd5fc774f1a799240090a459c39e9c8ebdbcb8efb96d"
    sha256 arm64_sonoma:  "2a67dc3d464a2b81a340d6e23aa9acf08158102dda283b2cba3dc2ea5cf2ad0a"
    sha256 arm64_ventura: "61dedc8b934fec27ad6e5c416abd37f5301e25aa3e2348ccf204d85c96e2c656"
    sha256 sonoma:        "1b82df0fc24deb0ea4fbd4e7890307d6cf1ab7ffadfb393663d64568dccea46f"
    sha256 ventura:       "efbaa296fc54eba52d0b1b1d73e659800052766bfa3a621894bd8f842ee4b813"
    sha256 x86_64_linux:  "d5f95e30c56cf41331e9fc0878f82d62761e44fe76379917db1803e8f05315ff"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-Dlibwebsockets_DIR=#{Formula["libwebsockets"].opt_lib}cmakelibwebsockets",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    fork do
      system bin"ttyd", "--port", port.to_s, "bash"
    end
    sleep 5

    system "curl", "-sI", "http:localhost:#{port}"
  end
end