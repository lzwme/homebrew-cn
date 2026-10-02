class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v5.11.0.tar.gz"
  sha256 "8cb24c6e6be1fa7ff05075c4560ca8b537a7ef48f9e6f465af4ea455794d74f4"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6629bf162e1c6e83cc0b2b99d5ba8224b167a2d1cb967d4a3c74c103311ac39a"
    sha256 cellar: :any, arm64_tahoe:       "da93631de5d68d6e676f87d7f0da2ed6892e1c8c1bff443869e104dd643b59f9"
    sha256 cellar: :any, arm64_sequoia:     "ea9a67204fef514bc1d7d0256e914aa12a30abb53c3ba5eac56aaefde6924c6a"
    sha256 cellar: :any, arm64_linux:       "e0ed36c57576ce5e85be33cf38682f69cca8a240afe7f2ff4c125ac94fed8520"
    sha256 cellar: :any, x86_64_linux:      "f70d0d35b007b070f2638b097e5c200706e496569e79013edb60c6dbb7f5148e"
  end

  depends_on "bindgen" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "perl" => :build

  on_macos do
    keg_only "it conflicts with OpenSSL"
  end

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGENERATE_RUST_BINDINGS=ON
    ]
    # Build with ENABLE_DIST_PKG to avoid conflicting with OpenSSL symbols and files,
    # https://github.com/aws/aws-lc/blob/main/BUILDING.md#distribution-packaging-mode
    args << "-DENABLE_DIST_PKG=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # The jitter entropy collector must be built without optimisations
    ENV.O0 { system "cmake", "--build", "build", "--target", "jitterentropy" }

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    bssl = OS.mac? ? "bssl" : "aws-lc-bssl"
    output = shell_output("#{bin/bssl} sha256sum testfile.txt")
    assert_match expected_checksum, output
  end
end