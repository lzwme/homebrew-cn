class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://ghfast.top/https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "567eb94c5a8f88271c31f29bbe8fbaa3b7401516f1218f56b18dfab70dcbd0e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb9e183a64b3bb564db562b3465c7441c87a0326851921ae5b61aabd95e866ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e096993136c1e22881c3aa3fbc60e80725a57bb559d3935a57a5452c79150bbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e003f286363a9fab4a2f3b46b3f02530c9c2b10a1669a087cc8452398e0f900b"
    sha256 cellar: :any,                 arm64_linux:       "eec0da677ae7eb4cd748f69128da80d888d40cd7aab77b8972208eb76a6de553"
    sha256 cellar: :any,                 x86_64_linux:      "5182ea8b98304010c68f864a99c8111d3bc678e66bcc355ae78966b6bee4c394"
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