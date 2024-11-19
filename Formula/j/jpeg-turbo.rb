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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "45448929e1c82c5c958da022e2c4396d8c5e7d753005da3dce89fe4f33b80d91"
    sha256 cellar: :any,                 arm64_sonoma:  "5f9b4512cc023a468d69a021eb4ce1a6cc112a94202f7a6c2c2a69982c210f2b"
    sha256 cellar: :any,                 arm64_ventura: "8f8c316eca20f02b946386c2bfd11ced6d1953272336eb01661779697d6f7b55"
    sha256 cellar: :any,                 sonoma:        "39ec0259e399be685749b2a9cef9cef6ba25314ff2fe32be0e4b0cbcb903e070"
    sha256 cellar: :any,                 ventura:       "8cc44d75e66f9fd844d9275b5289b2dbf3ffad9bc1651391ae84e1406b5c6a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c5a765ce6321ddfb4704d06037ae21ca71883135581c4717f395736cb448c2f"
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