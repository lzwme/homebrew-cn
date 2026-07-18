class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "57a94720571684b824a34cc5746f75d91c7c25617259e24e0d92c935111833e9"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "63849a86d6bbab6fe45fc12f0883cc523f52437568424b7f1d2b6843d9347366"
    sha256 cellar: :any, arm64_sequoia: "29b5edc16068065b2326c023725ec9b2c6c2fa8793f45e6c54fec9842aeed295"
    sha256 cellar: :any, arm64_sonoma:  "669623a848435a866c321c476da8cadc8c86cad97e601bd6aa94921f3a2a306d"
    sha256 cellar: :any, sonoma:        "2cea763940db33a9d000a505373932d7a84fed49b9232dca63ff1358c30f5e12"
    sha256 cellar: :any, arm64_linux:   "98b2db90dc41f1e8ecccffe8b31970566f443f1826b694c8680ee668521a1357"
    sha256 cellar: :any, x86_64_linux:  "221bc3823229783e6e28aa68e6dc4b8d556e66f8584ce0f59303748dd12426e4"
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