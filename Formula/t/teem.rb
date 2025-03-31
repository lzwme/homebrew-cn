class Teem < Formula
  desc "Libraries for scientific raster data"
  homepage "https://teem.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/teem/teem/1.11.0/teem-1.11.0-src.tar.gz"
  sha256 "a01386021dfa802b3e7b4defced2f3c8235860d500c1fa2f347483775d4c8def"
  # License is LGPL-2.1-or-later with a non-SPDX license exception for linking
  license :cannot_represent
  head "https://svn.code.sf.net/p/teem/code/teem/trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "81b45cdf2ea8755adac691f6e58accc314cf9ddfe9152c3f017fd839df3da9c2"
    sha256 cellar: :any,                 arm64_sonoma:   "3e9555bbe75fe5a36a3f62a36434158fa024153accdb69266ffce6d59254fed7"
    sha256 cellar: :any,                 arm64_ventura:  "675bc15ec206fbcdd01c475ae95b82f8fbb5f8143bd781ee87ba09971eb75d84"
    sha256 cellar: :any,                 arm64_monterey: "1c2da9c13e69b5cf2729b29ee33b48208963735e6e0394a17709993e6457a0e3"
    sha256                               arm64_big_sur:  "92abe3197ae4ee54df9af997f519538bd8e2b93f5221185f02aaa61de4b5e5aa"
    sha256 cellar: :any,                 sonoma:         "c65d52399cfdd28153cde34b05075a2be6fb2e1530f5b6f9d3a971fcf4115c27"
    sha256 cellar: :any,                 ventura:        "d4dec6840b897d0a4c59e41beb0802a6fb1c4736974558c4f96485ad3bb34792"
    sha256 cellar: :any,                 monterey:       "f179c33f2bb70a99d4f52e47f21dd8be70e49642607f47af90b1d5001f369d48"
    sha256                               big_sur:        "c7c9999dbb12db2cfd64815a3df772be7222278bb22e857b72d0db0101d498af"
    sha256                               catalina:       "105f54c1cb830584bcf694756ab18eab2a7d9a67e3226699272c4449cc2f816e"
    sha256                               mojave:         "439d02dd7f54d7f307b5984d00448a4e77309660e8f1c52e998ef9ea40fdcaa1"
    sha256                               high_sierra:    "4cb2692b42e79880161879605c3990cd5d0c4fbb171c7ccd003bb9d6bb0fee09"
    sha256                               sierra:         "31d19cd9e0e4c064fb743c41a286736503e61b1d5e4b81f29140fcebf2cde2c8"
    sha256                               el_capitan:     "5ade8dc18d0c66ac154d802df6c64e88222781b6fc427a841fb1f4047f8c4e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b136f971a5b05201d52c353da5db32fb4d0781d79ded3ac590425f03e12ea3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5940970f22f2f7c70ad15cda8f227df675d47924d4a37ff5461699dde188f7f"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    # Installs CMake archive files directly into lib, which we discourage.
    # Workaround by adding version to libdir & then symlink into expected structure.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS:BOOL=ON",
                    "-DTeem_USE_LIB_INSTALL_SUBDIR:BOOL=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install_symlink Dir.glob(lib/"Teem-#{version}/#{shared_library("*")}")
    (lib/"cmake/teem").install_symlink Dir.glob(lib/"Teem-#{version}/*.cmake")
  end

  test do
    system bin/"nrrdSanity"
  end
end