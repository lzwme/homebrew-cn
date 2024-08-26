class Cling < Formula
  desc "C++ interpreter"
  homepage "https:root.cerncling"
  url "https:github.comroot-projectclingarchiverefstagsv1.0.tar.gz"
  sha256 "93252c72bae2a660d9e2c718af18b767a09928078a854b2fcd77f28cc9fa71ae"
  license all_of: [
    { any_of: ["LGPL-2.1-only", "NCSA"] },
    { "Apache-2.0" => { with: "LLVM-exception" } }, # llvm
  ]

  bottle do
    sha256 arm64_sonoma:   "5ea8c62c558034d2b35e8a07bcf60f77cad73dd55c470ef7060e53dc3bdfe758"
    sha256 arm64_ventura:  "1e4a68506aa987b22e1dc4bf79dc6029ab256d67d1eb2156b1096301c8374ff8"
    sha256 arm64_monterey: "d184739cbaa69fab0e41777d5f127c86b7872838f93e104b64a8e99455d4b698"
    sha256 sonoma:         "7bcc51735312ae4301d05661c7f8ee4863212a546b4e04ce341c788bda7fa5cb"
    sha256 ventura:        "5d31305b7d107af4feee3aae605f7d349d94e3f3776d801af575fad704c0de47"
    sha256 monterey:       "0d27db6c6221b1ded0c2e1db375bfd2d10f402cd2de0702f4c0916761f7fdcea"
    sha256 x86_64_linux:   "c93cc9a4cc0696cda21c4b4906e315967f82f9f2af091889d242da886a809862"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "llvm" do
    url "https:github.comroot-projectllvm-projectarchiverefstagscling-llvm13-20240614-01.tar.gz"
    sha256 "c8afe609e9319009adf4e0fcb5021b663250ffbac1212c15058effb9ae6739d8"
  end

  def install
    # Skip modification of CLING_OSX_SYSROOT to the unversioned SDK path
    # Related: https:github.comHomebrewhomebrew-coreissues135714
    # Related: https:github.comroot-projectclingissues457
    inreplace "libInterpreterCMakeLists.txt", '"MacOSX[.0-9]+\.sdk"', '"SKIP"'

    (buildpath"llvm").install resource("llvm")

    system "cmake", "-S", "llvmllvm", "-B", "build",
                    "-DCLING_CXX_PATH=clang++",
                    "-DLLVM_BUILD_TOOLS=OFF",
                    "-DLLVM_ENABLE_PROJECTS=clang",
                    "-DLLVM_EXTERNAL_CLING_SOURCE_DIR=#{buildpath}",
                    "-DLLVM_EXTERNAL_PROJECTS=cling",
                    "-DLLVM_TARGETS_TO_BUILD=host;NVPTX",
                    *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # We use an exec script as a symlink causes issues finding headers
    bin.write_exec_script libexec"bincling"
  end

  test do
    test = <<~EOS
      '#include <stdio.h>' 'printf("Hello!")'
    EOS
    assert_equal "Hello!(int) 6", shell_output("#{bin}cling #{test}").chomp
  end
end