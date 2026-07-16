class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "f9ad6bde29eb9c8ce585085d9a12bb2ffe89bfd940a631f760eeb1b2d9b2d1a7"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0123ff1169072b5b1adc0b316a37072ac7ebe60f3df989d26756ac784e4a4931"
    sha256 cellar: :any, arm64_sequoia: "755998f890adfee164c21388a37cd9e67a148cde6be72a63a4fb1bcef760f601"
    sha256 cellar: :any, arm64_sonoma:  "441e6e00735b957ba47d1d67a05660d633f213a2b5c0590012fea09d3bee8110"
    sha256 cellar: :any, sonoma:        "c8d188ebb3ffb6c83d49692de2bee317fa1be2afd0987d02380fd298c461ddc3"
    sha256 cellar: :any, arm64_linux:   "0340a8937071d2fed042638d3ca05718b21a80e2cb82dcc2afe7dc637aa270d2"
    sha256 cellar: :any, x86_64_linux:  "61ed349a4eb90c3026e9dfc251f3c053036f12b8b19760a514e15db259c668aa"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "perl"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_BINDIR=bin
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # The jitter entropy collector must be built without optimisations
    ENV.O0 { system "cmake", "--build", "build", "--target", "jitterentropy" }

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    output = shell_output("#{bin}/bssl sha256sum testfile.txt")
    assert_match expected_checksum, output
  end
end