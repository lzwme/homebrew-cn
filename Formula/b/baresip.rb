class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://ghfast.top/https://github.com/baresip/baresip/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "481db747f9946c0304dab584f5b64dd05bfb847a701b2263aa0346d76dab503c"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "ae6c0e82693a214b521cdc6870d7c0bca1e10f784e15ad2b6c4ab3ef7cb1b9b7"
    sha256 arm64_sonoma:  "c3c244ebe90ebb0ff465b64f9ae39b2181ea8b3ba3ddbfa07f7ff01cf55718dc"
    sha256 arm64_ventura: "91ef17b44f9f3ce07ee35e83de49e97a7305b391bd667e00cdbfc8385f663119"
    sha256 sonoma:        "3aad1af607870a3207523ac0e41a2d6e761b04eee1151e4673c9a95e1d547e48"
    sha256 ventura:       "e6ddf3e8643e6eda34506a078146dde8f9c52077d54cf2e62206b6261a84fc90"
    sha256 arm64_linux:   "f6138ad83489afbd654964896a391d2167a1b36b181ba40576ece40e38f2a3b3"
    sha256 x86_64_linux:  "d4ff4f8644e3525fea7ab3fbe6c236906e7ea5c5cc61339974a2eed52c384efd"
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
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end