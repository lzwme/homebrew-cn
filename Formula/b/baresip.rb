class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.17.1.tar.gz"
  sha256 "9e6c1aae0a87175305c3a1bfe4e5cb40f0f170772746096a82ff9a225232d0f9"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "7fce61187944891b10741ad6d5c71429553201f0576eca32bf5116376b2b9ca0"
    sha256 arm64_sonoma:  "d4e2193d9a9b30301350e161e263186cfe5e6f4e5abdb8841ba4cd3223d605a0"
    sha256 arm64_ventura: "35065bad3e4a8551355af4a681c518f3f3e9968fdb4daf727520588935fa0b66"
    sha256 sonoma:        "42f04844044a5711b6f6ee9abbaa07b35539606b90cfa36b5ed379278881698f"
    sha256 ventura:       "6d684c260124f56f7d25ed3c63479c8955bb87eb022bfa716c69b4d98aa610f1"
    sha256 x86_64_linux:  "d832c6d750c4ae8698a2564dd6fd82f7844a57247877d26bcee418d3e2b18798"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"baresip", "-f", testpath".baresip", "-t", "5"
  end
end