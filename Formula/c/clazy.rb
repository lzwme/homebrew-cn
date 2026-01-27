class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.16/src/clazy-v1.16.tar.xz"
  sha256 "0fa9e9ce54969edfb2c831815b724be9ab89c41ac3a40c0033c558173c4c302b"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a19faeb9438b17329f1c3829f3cb12d0e3720d010058a89b77fcc4abe562c90"
    sha256 cellar: :any,                 arm64_sequoia: "0f644f8ed45cbee439c6256069cfd000a0a647849d0bb85360ee9cc146c1393f"
    sha256 cellar: :any,                 arm64_sonoma:  "e1b4f955c628acad175164de46e37ae7650352f9a73c61b196de1b053ba7827e"
    sha256 cellar: :any,                 sonoma:        "ddf864213bdf7e98ebceac758c0bc39e6b8bcbb59a1da457fd37c2ef5c2adcd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "770a1edc126d86489983a0a70f77919d14c278edc173d5ead3f9ea86b675b856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a029a850e25a88d11d416e23720f8f5607e9837afab8570efd061f951fe3fc8"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qtbase" => :test
  depends_on "llvm"

  on_macos do
    depends_on "coreutils" # for greadlink
  end

  fails_with :clang do
    cause "errors while linking LLVM's static libraries due to libLTO version"
  end

  def install
    # macOS has undefined symbols if only linking clang-cpp.
    # This is just the default value already set by CMakeLists.txt.
    args = ["-DCLAZY_LINK_CLANG_DYLIB=#{OS.mac? ? "OFF" : "ON"}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
      add_executable(test test.cpp)
      target_link_libraries(test PRIVATE Qt6::Core)
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