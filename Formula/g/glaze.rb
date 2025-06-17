class Glaze < Formula
  desc "Extremely fast, in-memory JSON and interface library for modern C++"
  homepage "https:github.comstephenberryglaze"
  url "https:github.comstephenberryglazearchiverefstagsv5.5.0.tar.gz"
  sha256 "378ba049e37b4c318fe0bdb2c6803369576707e40bad777959ed706dc361fc6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4dcc60b3e795ad4ef346a67cd8c51505d66aa22e0e695b1fff216f2f830ad2f0"
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
    ENV["CXX"] = Formula["llvm"].opt_bin"clang++"
    # Issue ref: https:github.comstephenberryglazeissues1500
    ENV.append_to_cflags "-stdlib=libc++" if OS.linux?

    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(GlazeTest LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 20)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(glaze REQUIRED)

      add_executable(glaze_test test.cpp)
      target_link_libraries(glaze_test PRIVATE glaze::glaze)
    CMAKE

    (testpath"test.cpp").write <<~CPP
      #include <glazeglaze.hpp>
      #include <map>
      #include <string_view>

      int main() {
        const std::string_view json = R"({"key": "value"})";
        std::map<std::string, std::string> data;
        auto result = glz::read_json(data, json);
        return (!result && data["key"] == "value") ? 0 : 1;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", "-Dglaze_DIR=#{share}glaze"
    system "cmake", "--build", "build"
    system ".buildglaze_test"
  end
end