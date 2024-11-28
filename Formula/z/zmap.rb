class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https:zmap.io"
  url "https:github.comzmapzmaparchiverefstagsv4.3.0.tar.gz"
  sha256 "c3b44b5b4c5148fd328164674c73f9b39cbbfdec1a8f5fdddd49d07e06852ee9"
  license "Apache-2.0"
  head "https:github.comzmapzmap.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "b4c68ccde2979edcd5b278fbf6e3592d8cc4fdf755c6e48d5931cb14af1a972d"
    sha256 arm64_sonoma:  "b5945796d4d8ff0bf8a0d3af23e600908acf937a1923e0d35be3e5f0805b5c1b"
    sha256 arm64_ventura: "9c200c28851289882f157874dda8b9d34d1d76ff642c256b90d2545d7fc8fee7"
    sha256 sonoma:        "40b7868ed2343f5092b8039dee1b97936ca086d7877f9d9887852019f98c713a"
    sha256 ventura:       "e15a7e116ea6b1b47f262099b0648c4f3dee0000f6e6b26e15bf0a3b96f6c6c4"
    sha256 x86_64_linux:  "d4e8dea812dd7b13a02a27f74215170d5e29c9a0808d7f2e248513ab6a4348e5"
  end

  depends_on "byacc" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "json-c"
  depends_on "judy"
  depends_on "libdnet"
  depends_on "libunistring" # for unistr.h

  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  def install
    inreplace ["confzmap.conf", "srcconstants.h", "srczopt.ggo.in"], "etc", etc
    args = %w[-DENABLE_DEVELOPMENT=OFF -DRESPECT_INSTALL_PREFIX_CONFIG=ON]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{sbin}zmap -p 80 -N 1 8.8.8.8 2>&1", 1)
    assert_match "[INFO] zmap: By default, ZMap will output the unique IP addresses " \
                 "of hosts that respond successfully (e.g., SYN-ACK packet)", output
    # need sudo permission
    assert_match "[FATAL] recv: could not open device", output

    system sbin"zmap", "--version"
  end
end