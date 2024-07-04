class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https:www.kdab.com"
  url "https:download.kde.orgstableclazy1.12srcclazy-1.12.tar.xz"
  sha256 "611749141d07ce1e006f8a1253f9b2dbd5b7b44d2d5322d471d62430ec2849ac"
  license "LGPL-2.0-or-later"
  head "https:invent.kde.orgsdkclazy.git", branch: "master"

  livecheck do
    url :head
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80dc170c7ddac95d9965a56a6c4692222d39f6163177427aace94c9021caa9d8"
    sha256 cellar: :any,                 arm64_ventura:  "00bb1c34c4834dccf37b8a482ebb330877a7c389b44bb3639d3bb758008610bb"
    sha256 cellar: :any,                 arm64_monterey: "c82c91308487e7ac63bcdf0873723b4aa67fc5d01f1701f6e24ef3bf560c5c38"
    sha256 cellar: :any,                 sonoma:         "02191ae7a0ad0299d036b8302fcf8b58a6b97fa5054f185a9181fae5e933822a"
    sha256 cellar: :any,                 ventura:        "882362cce46ab78383f72b2aefe4e18df5f867760f1bae674fc1c7f40b05f83e"
    sha256 cellar: :any,                 monterey:       "eed61eae5ed8a521181fb4d99ce75fc15b8d3de0fff387df7500fe4d96bc9de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4e28a3724c3444ce21c5f7fe53fc68e87ac3508c9d44236c36026a0cf8bc863"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "qt"      => :test
  depends_on "coreutils"
  # TODO: Backport patch for LLVM 18 support
  # https:github.comKDEclazycommitbe6ec9a3f3e1e4cb7168845008fd4d0593877b64
  depends_on "llvm@17"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # C++17

  def install
    ENV.append "CXXFLAGS", "-std=gnu++17" # Fix `std::regex` support detection.
    system "cmake", "-S", ".", "-B", "build", "-DCLAZY_LINK_CLANG_DYLIB=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core REQUIRED)

      add_executable(test
          test.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core
      )
    EOS

    (testpath"test.cpp").write <<~EOS
      #include <QtCoreQString>
      void test()
      {
          qgetenv("Foo").isEmpty();
      }
      int main() { return 0; }
    EOS

    llvm = deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+(\.\d+)*)?$) }
    ENV["CLANGXX"] = llvm.opt_bin"clang++"
    system "cmake", "-DCMAKE_CXX_COMPILER=#{bin}clazy", "."
    assert_match "warning: qgetenv().isEmpty() allocates. Use qEnvironmentVariableIsEmpty() instead",
      shell_output("make VERBOSE=1 2>&1")
  end
end