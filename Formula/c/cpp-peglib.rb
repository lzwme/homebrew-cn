class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "5a9b2fbe0eea36dd832509155d678b2524c923b08334d1a0132d69fec92af2b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a03121fea3748ac41402d62414e3d10e1c32355c87459ee02de26ee52b00589"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e4ef7c3973f313b66d8ee539c5a0cb19011c4e16fd705b3f165683adb392cb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b0fc3c87debf2e38d9260d134911b43e4bc55ffa255a0605a84ddb43dc143aa"
    sha256 cellar: :any,                 arm64_linux:       "9694c870aa005b0812d1c06ca0c0b8ff246be4c1a6b681f17476f3ffe89c5d80"
    sha256 cellar: :any,                 x86_64_linux:      "5c5521ec0c37d52e59619d5defa456c3708e7fcf4a4dd0ef6124c6e35e674a17"
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