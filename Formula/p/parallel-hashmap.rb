class ParallelHashmap < Formula
  desc "Family of header-only, fast, memory-friendly C++ hashmap and btree containers"
  homepage "https:greg7mdp.github.ioparallel-hashmap"
  url "https:github.comgreg7mdpparallel-hashmaparchiverefstags1.37.tar.gz"
  sha256 "2ac652be0552fcb53a1163c08c1f28f29f0756594fcc587eebb4d8b363153709"
  license "Apache-2.0"
  head "https:github.comgreg7mdpparallel-hashmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d35958ae9cb30dbf15d9cca4b5dc4a6b3d50aced16db2cca21b96d1c2a550216"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <parallel_hashmapphmap.h>

      using phmap::flat_hash_map;

      int main() {
          flat_hash_map<std::string, std::string> examples =
          {
              {"foo", "a"},
              {"bar", "b"}
          };

          for (const auto& n : examples)
              std::cout << n.first << ":" << n.second << std::endl;

          examples["baz"] = "c";
          std::cout << "baz:" << examples["baz"] << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "foo:a\nbar:b\nbaz:c\n", shell_output(".test")
  end
end