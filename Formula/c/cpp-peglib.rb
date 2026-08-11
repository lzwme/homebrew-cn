class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "c06a0068cc1b629607c17e8e503e07c80a53d58d5f1412a1a16151464cc3bcde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7b92e5941d7dc1964dbabc25713cc12f3cae23fd289bae8a31f62102270b537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bed88dae16233da52c000237b568868d984aa42a615f7949db56a1876f68470"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f50f344cd3ea48b335e3e7ebf75bba1eb3238b8f33624f7c116e1d786726f482"
    sha256 cellar: :any_skip_relocation, sonoma:        "44c7d3262491aba6413fe8e656d4f6d93b0b0bf28ad266dda516a3a35d557933"
    sha256 cellar: :any,                 arm64_linux:   "0e050ebbc8e395063354414eaf35220990e690faf5168bc8db8c104f78ee101e"
    sha256 cellar: :any,                 x86_64_linux:  "130ac0c15f997b072f33876eae026aa1053d1003f2f5ffeafbd599e30db0e43e"
  end

  depends_on "cmake" => :build

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