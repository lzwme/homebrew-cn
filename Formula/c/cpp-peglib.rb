class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "cc39c7f80fddeae03aabaaa755f05ab64d8c2b8e0cd80d01ea20438f0acb61c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b71c5b1574d0f7ad4c3eb98b59bca48c3448bb9c914234437845149e26dd7de5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "024237bd1c74c968aa8209c306e7b53a2e3f068a86a3437162881f2e9a8c76a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7276cb4b09aa1dc2f52afeef5dfa1fabaa880f567b9b8da1d3031f1281ed0171"
    sha256 cellar: :any,                 arm64_linux:       "808ae35bc7537176865590c92261d371b5940408344368b0c26bac99cb5c1942"
    sha256 cellar: :any,                 x86_64_linux:      "421933bb57f968795567bd2d1e6a55f84e36324f1d71086435f995fba958b82a"
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