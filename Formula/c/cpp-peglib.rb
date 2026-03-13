class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://github.com/yhirose/cpp-peglib"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "f2f29a90cd3681bdf3a7cfdf6a0b7dc00386dbf3183cd803c68babc5db9f3343"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f388819f643eed2ec19c0f72c0956ce873650b8b57fc760fa9de2140132e881e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2adf6db9243b037dcd391497f6b56a51b62f93e5e0bd8c2f220727f0ced0c0d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a65f38fc370659a6642bc0b42763b474b97e80e166f8545d1f0b5c505fb4b54"
    sha256 cellar: :any_skip_relocation, sonoma:        "866816c90861842a2821700d1b4dab40af057047ed898f8905f5c0158626382b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14854993c65a12b9ba6f0e94e289fe5d1b26aa9312f3ed123404ff77068b4645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54979d6dc73c76d89cf92f43fbd2a47275d2b422c4c8fb8090570eacc472621a"
  end

  depends_on "cmake" => :build

  # add missing direct <optional> include for GCC, upstream pr ref, https://github.com/yhirose/cpp-peglib/pull/337
  patch do
    url "https://github.com/yhirose/cpp-peglib/commit/033ea18345af05064ebe971bb283932ff92b2f12.patch?full_index=1"
    sha256 "8815a23bbf10fa3609fed764fde45d32cbc680d7530d111886d4728a6f5e882e"
  end

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