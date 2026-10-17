class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "6aa02ba5865f1020f194e2a911a2828d539588b922605032caf56ccd30a8c874"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35b1934d90ec16fff532b93f9da64581d917b5e8f5f6582c53ca61adc244c608"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dad3499b6a283656fe757952a8aa530fcfd3b9675dd9fbb8f85e2f8f8aadad3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "20cc64df50c3ce302b434e26e68f82cf5769486f04bde17397e87337e539197b"
    sha256 cellar: :any,                 arm64_linux:       "c52a19bd940acfb4a6e7afa54ea2b34596204e6ee58834417eb7e9ec9bf62bbe"
    sha256 cellar: :any,                 x86_64_linux:      "7b015b7b15610d7aae6b9a71ad286d1fb30d0322324c7b54c427952c0671edb3"
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