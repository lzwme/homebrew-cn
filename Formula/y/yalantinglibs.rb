class Yalantinglibs < Formula
  desc "Collection of modern C++ libraries"
  homepage "https://alibaba.github.io/yalantinglibs/en/"
  license "Apache-2.0"
  head "https://github.com/alibaba/yalantinglibs.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/alibaba/yalantinglibs/archive/refs/tags/lts1.2.1.tar.gz"
    sha256 "0e1bc99dae186024b7f2472fc850e8b01429cbbae6ba14414dee0f56ca93dca1"

    # fix clang compilation error, upstream pr ref, https://github.com/alibaba/yalantinglibs/pull/947
    patch do
      url "https://github.com/alibaba/yalantinglibs/commit/a9c55e6e24e38d2a640a67c0d6ae96095d973b41.patch?full_index=1"
      sha256 "4435b0d9e68942477d312acca6bba080ac908d05f46eee4292f247ab4217c32d"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26ec266b1cb421f569be3ddb50509a07e13f504f37f87c8d9bb3d77f8f5400ee"
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
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-o", "test"
    system "./test"
  end
end