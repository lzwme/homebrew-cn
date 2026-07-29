class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "2cbba8171acd312e12320f2a523466db736200a9a6431905c8c45f5ecc2ef8bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3db569d5863c7f0527f786fad6a17328889c40627b3b1d9cb271b3ea129a62e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5617249c2c4267b38993765d9507ed46e035d65dba97b259191e7b707ab58117"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "983f41bc40ad2ff7ba0b6c22afc9b5ed081dc3010f9e379780a31645214a1101"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5f3796c64ff2b4f9c72db1c3a9ac5c0e32fea94f803dfd6725cc25e2b1032b6"
    sha256 cellar: :any,                 arm64_linux:   "ea9c972cea9306ed42e11e09221e1014b79c0aaa613b400b192b7475cd848368"
    sha256 cellar: :any,                 x86_64_linux:  "99dc2290937ff2e4f1c0e3fc157c6899c4dee816129d62a362ba68e02e9a2c1c"
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