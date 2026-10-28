class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "a7f7722af528d345433ef42d3d0f52b4cb505f51a5a7f0c90c6f83eddeebf9ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5bcb0329096a2d7ce361abd929df0787aefbe15c97da86dbe3d82c3c8bea1c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eadea7fd8c705f7622cb73fbe024967af32510f6a62f75182b13053c532accec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7772a4e2e8b1094599522c7795d326d7294e972d23e4972200be4702328bcbf"
    sha256 cellar: :any,                 arm64_linux:       "15dded44249c0d9d08fa76517eef7ab46186f35fefcf1773455c312e1eb5b9c7"
    sha256 cellar: :any,                 x86_64_linux:      "5ff90bd6139d62461b365b53d218d351aab952a0fd2ffed9df1fe62968962af5"
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