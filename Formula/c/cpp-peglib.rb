class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "d56eea4e6b08b0544c0acfd3045ecd4b186e967f8579689072747e690a4fc4e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b97079d34b80fca959e91be815b4b51273cf1db63a064626f58d8840fe4428ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d997aacbac404ed8d3199b75f4b96e0ca9254fbd96cc525d8e12d4484c59e7de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e11de2ba196e1d59ea0f14273da16458427a11e979226725a1e7eaa5895427a7"
    sha256 cellar: :any,                 arm64_linux:       "3619382550d52cfe90a9e8fdd0ebd0f56194c181b8e9ddf77b7d75f62bac910d"
    sha256 cellar: :any,                 x86_64_linux:      "b5bbb4bf562353f1b810f8bf7f8679c8d5c7d6d07cee2d3cf91608c93454375e"
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