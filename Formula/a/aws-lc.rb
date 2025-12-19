class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.66.1.tar.gz"
  sha256 "44436ec404511e822c039acd903d4932e07d2a0a94a4f0cea4c545859fa2d922"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d30dcf884b76d61d0aad4dfeee676fb034348b4628af9feac0f49cd489ec6865"
    sha256 cellar: :any,                 arm64_sequoia: "3fdb0a50dd3e6afaa15afe2f45cbe0d70272d1dda6db4bee475b144c82435f3c"
    sha256 cellar: :any,                 arm64_sonoma:  "ea766ccca39d400378df1b24a4f275aac8839404f72a9c9dfafd9d2dd9cfe534"
    sha256 cellar: :any,                 sonoma:        "0ca609396bb881a8a4ac4e45939e7b121b33506d7c80bb988af51edbca9e309d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b1f3f01d292965e8e21bdad5db17bdb4f0783ecd66f4052774404ee92a1be46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1c3e747bfd8bd55c83b51096eb9c3314235c877705a1035a5bd67d773a8a8fd"
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