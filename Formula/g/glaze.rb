class Glaze < Formula
  desc "Extremely fast, in-memory JSON and interface library for modern C++"
  homepage "https:github.comstephenberryglaze"
  url "https:github.comstephenberryglazearchiverefstagsv4.3.0.tar.gz"
  sha256 "72cd174ad8839bc526a679a5a8ebf4bb18f3cb850a34fcfd3e89970f83c4d384"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b5fb40b50a71c6a2192ff81860e61a0b744b620ef2be0028834351332235de89"
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