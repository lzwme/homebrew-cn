class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "4ffdf64dbbf02a037a059a21be1e04b493fa8a52b2647b3ebc100e26feca3056"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14af47806ff7ae77751727edd7871713f89916e08979ab6a0762a9166cd2fc16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "87961d8ee8070c79949bb28a4fa08dbff42c53e21c0bb4c0e7fdde708fc7faa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f965d0028b8d570e556cc8948b6f5458995d3f26e853689a11fac67f32a817c"
    sha256 cellar: :any,                 arm64_linux:       "a7084e73a0fa25f649b73f2e5cd21f5cdb7ac73e8e5c47ef95d16e0ea4117bc1"
    sha256 cellar: :any,                 x86_64_linux:      "f2a1a14fba6a200270795578246fe4512bded6ee7c3c957fa2db196b2655591c"
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