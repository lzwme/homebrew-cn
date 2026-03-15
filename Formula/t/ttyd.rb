class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://ghfast.top/https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 9
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "7166e8513b95f5c06e7fb778c5bfd7ba3758609e30a45777e42a4a1121c1441f"
    sha256 arm64_sequoia: "17c2a244deb6508040e5151ae79e42dafe6f3e7af9784a121d61fea31f676873"
    sha256 arm64_sonoma:  "458b69434d234bdef696fb310ad9c2b798b172229a32bd759cc4849e68290e5a"
    sha256 sonoma:        "fae6b4ba2689822e9570a510bfcc4e0a2e4983d75c2cffd68f6e312fdc7674a8"
    sha256 arm64_linux:   "34780d7f45409871a92c99e3811592584b431129cfecbfe7088a710775aae614"
    sha256 x86_64_linux:  "f534e0b04dbb1dd1c25adba55cf9578b03f774e6972bf5cfde23db221fb5e999"
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