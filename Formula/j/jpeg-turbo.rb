class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https:www.libjpeg-turbo.org"
  url "https:github.comlibjpeg-turbolibjpeg-turboreleasesdownload3.1.0libjpeg-turbo-3.1.0.tar.gz"
  sha256 "9564c72b1dfd1d6fe6274c5f95a8d989b59854575d4bbee44ade7bc17aa9bc93"
  license all_of: [
    "IJG", # libjpeg API library and programs
    "Zlib", # libjpeg-turbo SIMD source code
    "BSD-3-Clause", # TurboJPEG API library and programs
  ]
  head "https:github.comlibjpeg-turbolibjpeg-turbo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c43b108ab9895d7aa1f649d9d3b10da482657eb1216d060577142b805cfe490c"
    sha256 cellar: :any,                 arm64_sonoma:  "03d179652a6d36ece4f02bbbc091ff6e3bb1d9454ba4e7a160c8d2fbab83b7d6"
    sha256 cellar: :any,                 arm64_ventura: "a9b6c86773453e3973ce817c15357acd3d16c6d839dd2b4b27b8ecd46efd5ac9"
    sha256 cellar: :any,                 sonoma:        "71334a8545e4e669f06c88c11e9b0adddce19a797f088dcc3db5d6513d0861bb"
    sha256 cellar: :any,                 ventura:       "9bd429d9b147fb9f042b70e907c50f5287572282c1f29bb243082c7a13e24ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e49b8d9e91e96ab8a404ab29746f5705c204001ff745d2aa2c93e55b2798d8"
  end

  depends_on "cmake" => :build

  on_intel do
    # Required only for x86 SIMD extensions.
    depends_on "nasm" => :build
  end

  # These conflict with `jpeg`, which is now keg-only.
  link_overwrite "bincjpeg", "bindjpeg", "binjpegtran", "binrdjpgcom", "binwrjpgcom"
  link_overwrite "includejconfig.h", "includejerror.h", "includejmorecfg.h", "includejpeglib.h"
  link_overwrite "liblibjpeg.dylib", "liblibjpeg.so", "liblibjpeg.a", "libpkgconfiglibjpeg.pc"
  link_overwrite "sharemanman1cjpeg.1", "sharemanman1djpeg.1", "sharemanman1jpegtran.1",
                 "sharemanman1rdjpgcom.1", "sharemanman1wrjpgcom.1"

  def install
    args = ["-DWITH_JPEG8=1", "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"]
    if Hardware::CPU.arm? && OS.mac?
      if MacOS.version >= :ventura
        # https:github.comlibjpeg-turbolibjpeg-turboissues709
        args += ["-DFLOATTEST8=fp-contract",
                 "-DFLOATTEST12=fp-contract"]
      elsif MacOS.version == :monterey
        # https:github.comlibjpeg-turbolibjpeg-turboissues734
        args << "-DFLOATTEST12=no-fp-contract"
      end
    end
    args += std_cmake_args.reject { |arg| arg["CMAKE_INSTALL_LIBDIR"].present? }

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--rerun-failed", "--output-on-failure", "--parallel", ENV.make_jobs
    system "cmake", "--install", "build"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace [lib"pkgconfiglibjpeg.pc", lib"pkgconfiglibturbojpeg.pc"],
              prefix, opt_prefix
  end

  test do
    system bin"jpegtran", "-crop", "1x1",
                           "-transpose",
                           "-perfect",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
    assert_predicate testpath"out.jpg", :exist?
  end
end