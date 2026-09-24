class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v5.10.0.tar.gz"
  sha256 "dcac84da23dcbdd38f297f64eb3f6c419c240730f70fbb319ea93c4c54a6084c"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9981b5b620cc64ace30724ddd053a39369b4735e66afcce767e86995aabd457a"
    sha256 cellar: :any, arm64_tahoe:       "63e58169e5352d447f145e34fde660f5fd0b408ad8f14fcdad9e3b513b1824e1"
    sha256 cellar: :any, arm64_sequoia:     "a80c6239e4873ecc74e2b30062f07017f21d02f79cf5cb1f1c8107edbcdda815"
    sha256 cellar: :any, arm64_linux:       "517c83848d97fee0bc0574985688396d7be570bcec68c4519955e44a6dc065db"
    sha256 cellar: :any, x86_64_linux:      "7614897981128e1e3f4b2d248bb5f9d3df0dbd2988ecd549477a43cee90b4599"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "perl"

  deny_network_access!

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