class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https:tsl0922.github.iottyd"
  url "https:github.comtsl0922ttydarchiverefstags1.7.6.tar.gz"
  sha256 "47fd8ff4fedfca225e710464411ae048885113c6bf01b2d87cb368e32434e062"
  license "MIT"
  head "https:github.comtsl0922ttyd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "0ceddbde97319b37187be13e17b0feaa6b136cf926a58f1d47862b96674486a9"
    sha256 arm64_ventura:  "0e14c3f4fdc45b3e822ede4d973d88563ae4dc590ff5486e472cd197ae610f8b"
    sha256 arm64_monterey: "1a94c80a617155b24cda32b10bb5d7ef50e71c8164cec3c5c8f2c3e91dcb935f"
    sha256 sonoma:         "88cbef20552d7c4936c950c978f0a2757fcf2a1940c70e350f3b058b156cd4d5"
    sha256 ventura:        "7a82d2e4970dbd5afe2396c5932ccbd12524dfa6e795b3c2304554f7254d4fdc"
    sha256 monterey:       "4618e74269b68e841a08480c5b7dde460b33f7625797741fc22af819ee306c13"
    sha256 x86_64_linux:   "0b7c32956128427cea9f5d34d9e13bb339e5cab18d466990111647eed5f661e6"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd

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
      system "#{bin}ttyd", "--port", port.to_s, "bash"
    end
    sleep 5

    system "curl", "-sI", "http:localhost:#{port}"
  end
end