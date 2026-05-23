class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://ghfast.top/https://github.com/biojppm/rapidyaml/releases/download/v0.13.0/rapidyaml-0.13.0-src.tgz"
  sha256 "b70b484b612152b0dbb2ca61178c9534d80c392fe36d4d54e75d127ec8864d52"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92bcff5ffd8cf7713911861bbc942a649de0691ff2f06ef60b9e6e40553614da"
    sha256 cellar: :any,                 arm64_sequoia: "377558a950bb05e8334457af1f26e60394e5d7b5be95a50222cc4583724aaf67"
    sha256 cellar: :any,                 arm64_sonoma:  "82b1faadb5e3c13c51eec1f850c2206a1b0c74946b32d52b6ac6a508aa49cdda"
    sha256 cellar: :any,                 sonoma:        "7b7ca08e3b741a23036e992675bb83a20d880c7e663e8ec77241429daf17edcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca197f1e24a976d46bd49cb860335a00049dbd03a3e3c97b359d9d60e8642110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d5fe161c7e79500c68446d90e1075e6d2e72c01f7a5d15d1a09fe9a2e68b503"
  end

  depends_on "cmake" => :build

  conflicts_with "c4core", because: "both install `c4core` files `include/c4`"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ryml.hpp>
      int main() {
        char yml_buf[] = "{foo: 1, bar: [2, 3], john: doe}";
        ryml::Tree tree = ryml::parse_in_place(yml_buf);
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lryml", "-o", "test"
    system "./test"
  end
end