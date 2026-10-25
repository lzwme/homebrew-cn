class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "c61a8edb590ee2ac171f79046421e40436b03e3e9730dbff3b68ab86419fc031"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9afef276785f08f460f2edc97518d3a0bf8d62395274f15ac4b7d45e2c34f68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c47474808f84dd332df5cdfa5b6acc338f373d1ae842b2f18ddb6f4724fed451"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfea0fd2abd5da79085f66cb4a9b8b70368cf21054fc6feb546a223165996002"
    sha256 cellar: :any,                 arm64_linux:       "baad1e5f08ef6067ab60d6f5765363c6201788f93964d3fe320d68918e477a89"
    sha256 cellar: :any,                 x86_64_linux:      "80ac176e20ce125ce4708c0c7c17fb208e329797b14a30e408778abbf3739c3e"
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