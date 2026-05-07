class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://ghfast.top/https://github.com/biojppm/rapidyaml/releases/download/v0.12.0/rapidyaml-0.12.0-src.tgz"
  sha256 "f96eb31823154e01c176357bf6c5504acc94d65804bb8d3d8957e16c54b88e43"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7944b08d8a867a5e7236344310d6c74d134e44b4fa926b1001dcf341d72a1a0a"
    sha256 cellar: :any,                 arm64_sequoia: "e1e7319072c539bc68181756aacfff77eb70966fb43d93a612e0f6c1c65b4b0b"
    sha256 cellar: :any,                 arm64_sonoma:  "c019747421bcb924973c8c21ae13de2a8f9c551a7a1879ddf158ff8b3591256f"
    sha256 cellar: :any,                 sonoma:        "20d146efeeaec3db6e2d08075d3bf959222d6c27138979dd1f1df540b1fce90d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db6a99b3522146cd3cb2f1e1663e6fa8bd2172d22e0a593743fe136153a93ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2a4fbaf406c263ea1271de979d6111ae669d235af3f44bfc1eaed8b3fd2c9d9"
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