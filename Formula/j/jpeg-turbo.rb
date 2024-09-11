class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https:www.libjpeg-turbo.org"
  url "https:github.comlibjpeg-turbolibjpeg-turboreleasesdownload3.0.3libjpeg-turbo-3.0.3.tar.gz"
  sha256 "343e789069fc7afbcdfe44dbba7dbbf45afa98a15150e079a38e60e44578865d"
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
    sha256 cellar: :any,                 arm64_sequoia:  "a5a4627a27bd2c560743d7344f53f050bafc9fc613196a6bca686c1633ca4576"
    sha256 cellar: :any,                 arm64_sonoma:   "9ea422966185251d1073ba0f4a75c34b4ec497fc7819ea8de80f69fe8e6be18d"
    sha256 cellar: :any,                 arm64_ventura:  "b2d39242d1c78c5c4b275c36e3921371dc5ac1041aaea43764be1286efff5076"
    sha256 cellar: :any,                 arm64_monterey: "ef42d3c4beadfeac182acd43fea7fca8993c51dc1567d1f18330c1863d5feb42"
    sha256 cellar: :any,                 sonoma:         "477d3cee9b6e928a642e10be913e189e9f505e5d662180f2941c4a0b66c4ccc4"
    sha256 cellar: :any,                 ventura:        "660f3f3fe22015e9332c7a9ecfaeb03de181dc2edef3918396d227ecd9cbd7a1"
    sha256 cellar: :any,                 monterey:       "8d146c2ec1537eecac10291d6ecfaeb447e3a295faed46c7f43628aee5ec5baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fa10c311ff3da224a81663de1fedd246878a5e435edca0875f0fb2835b88191"
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