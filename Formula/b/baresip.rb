class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.13.0.tar.gz"
  sha256 "b5ab008802e1c2e58789ac572dcc1441944ec2110f8c2d8af24bf1e153e021c5"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "3e1c99d9bd1b579234e2ee2ed31a8a7b78e46b073bbf21abe198ca6da39e94d7"
    sha256 arm64_ventura:  "7cc591bfed26b346b6acbe374f523ebd9ac60a1d2365ea1f94eebc7d7a5c6735"
    sha256 arm64_monterey: "fdf6dc3c45a921f003493d79504d1c4c55b657cad379a0ecc262a5edfb08d5db"
    sha256 sonoma:         "f3e6e704b511696a5ba2a794c35d0e9568155fd66584965aca2d28f9b6e0f761"
    sha256 ventura:        "ff5d3849cac6477772d16caae1f670d5a40ab0621aee20f8b5c395bf6072b1c7"
    sha256 monterey:       "13bd7eb9e25e5e1206e1a8d914f04a447d28869cd847967e9c36c97c2fb5b9bd"
    sha256 x86_64_linux:   "792be6af109dde27c9adbd3c7c794b679c72a757242f1d2f167b8784f172b3f9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin"baresip", "-f", testpath".baresip", "-t", "5"
  end
end