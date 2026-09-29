class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "35cfae68f6e828f066df3c3c9ecce53765a67f780133c96a39f6dc49c8973c62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b21ed842eaa39d753b595a5a5311d18c90e823d97c59577ffeef782bdbdbed1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "184971ef2a670525bcf322643a7d0bcd8293e08b59be8aeb9925197d9bfb4916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d507d0f975120250610940e20ddb850e14abd0ee3d0970771d6c91ed015ba8b5"
    sha256 cellar: :any,                 arm64_linux:       "1d8ad1f8326b7366636e81c2b941d67a1dec7215e4e6cdef5e06e38f9c3356a0"
    sha256 cellar: :any,                 x86_64_linux:      "925697c5ed5fc7753e7050836360ca6926f908ee469e68e10e09efbd5e7e8bd3"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DPEGLIB_BUILD_LINT=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "build/lint/peglint"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <peglib.h>

      int main() {
        peg::parser parser(R"(
          START <- [0-9]+
        )");

        std::string input = "12345";
        return parser.parse(input) ? 0 : 1;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-o", "test"
    system "./test"

    (testpath/"grammar.peg").write <<~EOS
      START <- [0-9]+ EOF
      EOF <- !.
    EOS

    (testpath/"source.txt").write "12345"

    output = shell_output("#{bin}/peglint --profile #{testpath}/grammar.peg #{testpath}/source.txt")
    assert_match "success", output
  end
end