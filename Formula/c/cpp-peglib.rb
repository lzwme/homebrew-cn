class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "a80f0f7cff743da505fd72f57b6c1c477d7c811e087841726351484b888a4031"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4be4242a06f9c307b85af98cce6b89cae592e6704d6f3db903c7d4eaff2097e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6bde4f2a24e596b86080f1bba9e3e8ffec4e8e40ec0f1df282c04b2f249a18af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a16ecf5d6bb4cf67d239f05938f5d52f9dc47f4308d37a47e9cecce3829c765"
    sha256 cellar: :any,                 arm64_linux:       "a77bd3c8db84406f6db0193e3bbdfb7137930a0c917ba4a4dd1220859a2c9ca6"
    sha256 cellar: :any,                 x86_64_linux:      "bc5cc72fc36942e222af72dcf1533dfeb9b435cd57530d16b0caadc6c9f77547"
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