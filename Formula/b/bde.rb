class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://ghfast.top/https://github.com/bloomberg/bde/archive/refs/tags/4.33.0.0.tar.gz"
  sha256 "812c1cf02d307a8027898c0106ba49eff7cee4bce15a5ce0f2f27a890e753645"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b121495c94a278b6901f96b67fc54eb2b307abb8ae4eafb8e35d58d1901a139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e85f7317073e018e82e5acf13211c0bb8b1b958b54d7c3e95e8937a65ab92b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93dc8db192ca920b2a70583c34ef154e93eece511e7da71b9a3abc786f376b3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b94e551b396d78af3b504c538f6ccb8c069cd0832d7fa90bffd30f173ecd60c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fb745426d299999866a33a2f23bc09dbdf70ba5e1a12a6fa2b323048d3e8d91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ce9a3e83b348f4d0dd63820cedd5c9e67fc000563d5ae1cc6fe670255bb1b2a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://ghfast.top/https://github.com/bloomberg/bde-tools/archive/refs/tags/4.33.0.0.tar.gz"
    sha256 "3b8538d7e3e02e849abda6ff79ca7807a1726f303acc2d4d5e50639d5ddf842b"

    livecheck do
      regex(/^v?(\d+\.\d+\.\d+\.\d+)$/i)
    end
  end

  def install
    (buildpath/"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    rm_r buildpath/"thirdparty/pcre2"
    inreplace "thirdparty/CMakeLists.txt", "add_subdirectory(pcre2)\n", ""
    inreplace "groups/bdl/group/bdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groups/bdl/bdlpcre/bdlpcre_regex.h", "#include <pcre2/pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "bde-tools/cmake/toolchains/#{OS.kernel_name.downcase}/default.cmake"
    args = %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=./bde-tools/cmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}
      -DPYTHON_EXECUTABLE=#{which("python3.14")}
      -DBdeBuildSystem_DIR=#{buildpath}/bde-tools/BdeBuildSystem/
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~CPP
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end