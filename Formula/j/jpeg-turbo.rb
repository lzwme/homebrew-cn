class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https:www.libjpeg-turbo.org"
  url "https:github.comlibjpeg-turbolibjpeg-turboreleasesdownload3.0.4libjpeg-turbo-3.0.4.tar.gz"
  sha256 "99130559e7d62e8d695f2c0eaeef912c5828d5b84a0537dcb24c9678c9d5b76b"
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
    sha256 cellar: :any,                 arm64_sequoia: "f85cd191b0fce773ae3d3502395ee2d56eec5be7607a95834a13d63d22181d78"
    sha256 cellar: :any,                 arm64_sonoma:  "e936777455b6cb66819a7db9f4396dfd4d0b8c7b0d700ea28213780b16c2dac1"
    sha256 cellar: :any,                 arm64_ventura: "95a0c93dc8f316a7235471cf16203aa1efb595c4568294ef854510d3c0050699"
    sha256 cellar: :any,                 sonoma:        "54fe1e9ac8988d4461fcca02ac0f85b3d534acc0b9b42f6115a0ce423732d877"
    sha256 cellar: :any,                 ventura:       "0e7ef21719a1106c59fab1f82cbbd20144898fa29c0e74407b9d55ed14feb951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb799fd7e23195d2cb8ef8bf5282518a26f06864cc2d5a9d134a520916291e2"
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