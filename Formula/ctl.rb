class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  license "AMPAS"
  revision 10
  head "https://github.com/ampas/CTL.git", branch: "master"

  stable do
    url "https://ghproxy.com/https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
    sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"

    # Backport support for OpenEXR/Imath 3. Remove in the next release.
    # Due to large number of changes from last stable release to OpenEXR 3 commit
    # https://github.com/ampas/CTL/commit/3fc4ae7a8af35d380654e573d895216fd5ba407e,
    # we apply a patch generated from GitHub compare range.
    patch do
      url "https://github.com/ampas/CTL/compare/ctl-1.5.2..3fc4ae7a8af35d380654e573d895216fd5ba407e.patch?full_index=1"
      sha256 "701df07c80ad10341d8e70da09ce4a624ae3cccbe86e72bf07e6e6187bca96cc"
    end

    # Fix installation error: file cannot create directory: /CTL.
    # Remove in the next release.
    patch do
      url "https://github.com/ampas/CTL/commit/f2474a09f647426302472009649edb4c3daac471.patch?full_index=1"
      sha256 "9adb22c5558bf661afea173695bad0a23a19af12981ba31c9fc0c6f9129fe6f1"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fe479d769b76d72d7cdcadfe4c9b99caa251b93204927d3f71bd1bec237466c7"
    sha256 cellar: :any,                 arm64_monterey: "5ef0d21e45ca055e30b1ee1c6c78f16a749f1eb80a9a2b62a0997489e1010934"
    sha256 cellar: :any,                 arm64_big_sur:  "26c518d64d04dbb3064aad30c7690c93322d2b3707279d2d067cc675f1d18c19"
    sha256 cellar: :any,                 ventura:        "b96b52997cc38a4ca4acb6fba602debb1ddea7d3739c8a6311285622ec0bc71d"
    sha256 cellar: :any,                 monterey:       "a4d8980a501c5ba01d6eeb0ce99b1decdf3f66c24dd68024d50e1dbf3fc07a80"
    sha256 cellar: :any,                 big_sur:        "bb0fa672be164a10f03eabd6853a0a4a281d5941e85da93a31d6475da216ecc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a38d6e4ffb580fc7925f4bced13cc7d55cde1b9b184484686d324b0630783efc"
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "imath"
  depends_on "libtiff"
  depends_on "openexr"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCTL_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "transforms an image", shell_output("#{bin}/ctlrender -help", 1)
  end
end