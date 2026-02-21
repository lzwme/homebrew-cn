class Yalantinglibs < Formula
  desc "Collection of modern C++ libraries"
  homepage "https://alibaba.github.io/yalantinglibs/en/"
  url "https://ghfast.top/https://github.com/alibaba/yalantinglibs/archive/refs/tags/0.5.8.tar.gz"
  sha256 "49b631c191f139ff465b489663a620f3ae24af6baa236cc1e3d96f3ac7506d73"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/alibaba/yalantinglibs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "568fa71f67ad66eec83342e688ef18c7b35dd6678d37343236fcafd497e61591"
  end

  depends_on "cmake" => :build
  depends_on "asio"
  depends_on "async_simple"
  depends_on "frozen"
  depends_on "iguana"

  def install
    args = %w[
      -DINSTALL_INDEPENDENT_STANDALONE=OFF
      -DINSTALL_INDEPENDENT_THIRDPARTY=OFF
      -DINSTALL_STANDALONE=OFF
      -DINSTALL_THIRDPARTY=OFF
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include "ylt/version.hpp"
      #include "ylt/struct_json/json_reader.h"
      #include "ylt/struct_json/json_writer.h"

      struct person {
       std::string name;
       int age;
      };
      YLT_REFL(person, name, age);

      int main() {
        person p{.name = "tom", .age = 20};
        std::string str;
        struct_json::to_json(p, str); // {"name":"tom","age":20}
        person p1;
        struct_json::from_json(p1, str);
        std::cout << YLT_VERSION / 100000 << "." << YLT_VERSION / 100 % 1000 << "." << YLT_VERSION % 100;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end