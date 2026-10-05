class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "e26bd3f87ec723f62dbfbde76ea25e013e6f36066380ce5dde8fecc2466dcc91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b17ca66e757f06ef9e2f0033ac974c84476b8da1ad06508046b415512ea46b0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7c3819b9d957f8d786d6af57060c6a320f026b79fb4ee3678974289d431ad57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6903217c2c58eb2866c52f2c86cccc71f39ebd161d159b24028db2f5fa3111f5"
    sha256 cellar: :any,                 arm64_linux:       "0645aa88edf8e6092e605edf0986fb3bed1f85434fc00d6b654e2d09551d9101"
    sha256 cellar: :any,                 x86_64_linux:      "1bf8cb1379e69e34bcbf8fd88ac04c522094844b21a628671156ffc5640a505a"
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