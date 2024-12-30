class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.13/src/clazy-1.13.tar.xz"
  sha256 "6d36da0c9d4d2f8602fb52910bde34bf27501ff758f6182b1a46fa0a91779ef4"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "067a38e1a6f888c88202043ed9fe74fa71accfb9b0542dd537dc57e008681ab9"
    sha256 cellar: :any,                 arm64_sonoma:  "ceb22a17cd7551fcecabf720daba930640448979014e4f05b10ecea4acb67642"
    sha256 cellar: :any,                 arm64_ventura: "5815bd69a7e5bb7028dc381d174c17a936e667d996f995e72bfb28900f4c95be"
    sha256 cellar: :any,                 sonoma:        "7020fc1ed55382630a179a76b3047ec89faeb0b881b1718406641680831210d2"
    sha256 cellar: :any,                 ventura:       "2ac1f42184b5e62aa4ca3538f961e8b14f61208bad6ebf1900518657baad00cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf8ed997f6439a05e149fbc974eecc9c3c517f6c87b89f4e9582e74f84b046c0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :test
  depends_on "coreutils"
  depends_on "llvm@18"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCLAZY_LINK_CLANG_DYLIB=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
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
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <QtCore/QString>
      void test()
      {
          qgetenv("Foo").isEmpty();
      }
      int main() { return 0; }
    CPP

    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    ENV["CLANGXX"] = llvm.opt_bin/"clang++"
    system "cmake", "-DCMAKE_CXX_COMPILER=#{bin}/clazy", "."
    assert_match "warning: qgetenv().isEmpty() allocates. Use qEnvironmentVariableIsEmpty() instead",
      shell_output("make VERBOSE=1 2>&1")
  end
end