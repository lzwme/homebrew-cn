class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://ghproxy.com/https://github.com/podofo/podofo/archive/refs/tags/0.10.2.tar.gz"
  sha256 "565168132e8fbfcdbad4ea4c5567bcc57ebbffb4528f6273baf3f490a3cf7563"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5d6f4bd6103e2ea02056675f2a70db604979a89ad5b5a1b67b7f0fedd5f3e45"
    sha256 cellar: :any,                 arm64_ventura:  "d02a757b88f6293d253fa0efea2acb74a976317c77ff2027ad240e06432734d4"
    sha256 cellar: :any,                 arm64_monterey: "78fda71ee4e0ec571577d525ef4d3ae1d46a5ebd6549ffbcc5e305fbbda208a0"
    sha256 cellar: :any,                 sonoma:         "f6427587aab5819f70feac5cfb2c9ff633ab2b5da417e855bd14e75bee7d2fe4"
    sha256 cellar: :any,                 ventura:        "07fc4b06987a91e68901677b673e5aecf29747c440f52da9a046f6d4ef522b5b"
    sha256 cellar: :any,                 monterey:       "ccbd31dfb68217561d643890975edbe8b7f195f79baa2b6edfd4e4929be9b224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38b2fb776f88ec5afcea1b48a0f59d74e88cfb5fe25f2da60db8097f07ab1771"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_CppUnit=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_LUA=ON
      -DPODOFO_BUILD_TOOLS=TRUE
      -DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].opt_include}/freetype2
      -DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].opt_include}/freetype2/config/
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "500 x 800 pts", shell_output("#{bin}/podofopdfinfo test.pdf")
  end
end