class Libbsc < Formula
  desc "High performance block-sorting data compression library"
  homepage "http://libbsc.com"
  url "https://ghfast.top/https://github.com/IlyaGrebnov/libbsc/archive/refs/tags/v3.3.10.tar.gz"
  sha256 "8e0ad726d808402c3573da35b1fd8945eda6cfdeace6271569d4d516d964fe38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3301b293fcd0b47c63fa9de27dc96e6054c946fe56e7476220545edc7f047e44"
    sha256 cellar: :any,                 arm64_sonoma:  "42217b3ad9f6d8a901967c216cb650278f9bc30800da66fdefe78241d6dc5bb9"
    sha256 cellar: :any,                 arm64_ventura: "fb23c49b9f63e3e55f71af00be3fcae4594e20b6d187bc3bd15b62ef6d5f90a6"
    sha256 cellar: :any,                 sonoma:        "c1c6dced1b95d469779dc6247a3b38e89ac756d31c1268f976a461369e32c238"
    sha256 cellar: :any,                 ventura:       "6d50f5eb0364eca4328e4a0fa0020fde3bc7f32859868be7dfe059d4e64cff9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52623cf85811f0fd3705df49f4f742924be581ea417eba0db9f8fe226cf94f6f"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "bsc", because: "both install `bsc` binaries"

  def install
    args = %W[
      -DBSC_ENABLE_NATIVE_COMPILATION=OFF
      -DBSC_BUILD_SHARED_LIB=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"bsc", "e", test_fixtures("test.tiff"), "test.tiff.bsc"
    system bin/"bsc", "d", "test.tiff.bsc", "test.tiff"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.tiff").read),
                 Digest::SHA256.hexdigest((testpath/"test.tiff").read)
  end
end