class Glaze < Formula
  desc "Extremely fast, in-memory JSON and interface library for modern C++"
  homepage "https://github.com/stephenberry/glaze"
  url "https://ghfast.top/https://github.com/stephenberry/glaze/archive/refs/tags/v5.6.0.tar.gz"
  sha256 "6f21e4186ce14b5243a5d2e58419f45fda260da2c0fa9ef793a5c46eaa05b2b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0262c3bad0c6c324f6058a183a9d61b49a9c6ef4ac282498bdb3a3590d4ca404"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => :test

  def install
    args = %w[
      -Dglaze_DEVELOPER_MODE=OFF
    ]
    args << "-Dglaze_ENABLE_AVX2=#{(!build.bottle? && Hardware::CPU.intel?) ? "ON" : "OFF"}"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    # Issue ref: https://github.com/stephenberry/glaze/issues/1500
    ENV.append_to_cflags "-stdlib=libc++" if OS.linux?

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(GlazeTest LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 20)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(glaze REQUIRED)

      add_executable(glaze_test test.cpp)
      target_link_libraries(glaze_test PRIVATE glaze::glaze)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <glaze/glaze.hpp>
      #include <map>
      #include <string_view>

      int main() {
        const std::string_view json = R"({"key": "value"})";
        std::map<std::string, std::string> data;
        auto result = glz::read_json(data, json);
        return (!result && data["key"] == "value") ? 0 : 1;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", "-Dglaze_DIR=#{share}/glaze"
    system "cmake", "--build", "build"
    system "./build/glaze_test"
  end
end