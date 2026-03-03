class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "cdaa8dcd5f4ead8c82646fabef3c811381c4c7906de4489415e3fdf2558922f8"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f6a691a60b6fc37157c5353d82c21ccdfe2b88c3389f33a29dab9869bf1d1849"
    sha256 cellar: :any,                 arm64_sequoia: "4faf7fe72a9173100f30236a087f74b1f283adfc68839089729ff957fe06476b"
    sha256 cellar: :any,                 arm64_sonoma:  "759222f933b7d6e19bd2803e81ad57d75eabf1647172e0055cacce0b5b92389d"
    sha256 cellar: :any,                 sonoma:        "2892a62221e5b9689cfbfeefa10dac0314237b66b81f27876c2bef848009c06c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a394320dcc1a69f90a126819044c0688c726b40fbe5798c3963c1b8e766f8294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e524fa3d415609fc19c2f7596884dd6acdc18a934f4ad4c3b2da2fd02b5c8a"
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