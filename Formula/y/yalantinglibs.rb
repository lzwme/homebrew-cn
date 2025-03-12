class Yalantinglibs < Formula
  desc "Collection of modern C++ libraries"
  homepage "https:alibaba.github.ioyalantinglibsen"
  url "https:github.comalibabayalantinglibsarchiverefstagslts1.0.2.tar.gz"
  sha256 "91049e5c2931918fe57d7513c0cd2797e07c5e642aa40da40a511b0999ae2ec7"
  license "Apache-2.0"
  head "https:github.comalibabayalantinglibs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8086a786c602d66397f747f125e70cb1a8bea4d4aa143591ffb854e9681e1afb"
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
    (testpath"test.cpp").write <<~CPP
      #include "yltstruct_jsonjson_reader.h"
      #include "yltstruct_jsonjson_writer.h"
      struct person {
       std::string name;
       int age;
      };
      YLT_REFL(person, name, age);

      int main() {
        person p{.name = "tom", .age = 20};
        std::string str;
        struct_json::to_json(p, str);  {"name":"tom","age":20}
        person p1;
        struct_json::from_json(p1, str);
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-o", "test"
    system ".test"
  end
end