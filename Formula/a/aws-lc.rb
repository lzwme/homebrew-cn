class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v5.10.0.tar.gz"
  sha256 "dcac84da23dcbdd38f297f64eb3f6c419c240730f70fbb319ea93c4c54a6084c"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "85c9a51943b92003a1ad3467788789ddae3903ac0600a0956d2d6864d3defd4b"
    sha256 cellar: :any, arm64_tahoe:       "14c37b136e47dc5cd7791dc55f88d6ab9c9f982534763df3250c7023b77600e8"
    sha256 cellar: :any, arm64_sequoia:     "672471ade66cb9a8b724b8fa156b9e4bb0df9345b20ed9bec2e56cb8048aee64"
    sha256 cellar: :any, arm64_linux:       "0179677a5a36ae5473d6fabac273f44a6c7ec42f8b27a6d4e4e280dee3e5d041"
    sha256 cellar: :any, x86_64_linux:      "e3047d1ecfe8d5c8221f7db58124b85ce5da4340ab34edf41d1b95c045615ac9"
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