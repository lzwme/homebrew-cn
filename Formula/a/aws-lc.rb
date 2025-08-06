class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "1c434d294594a82f1c046aa4e172277b5b549f7b5c89225e3cb2222b94744ca8"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2c3b97cdde4ed07e1876f9c854d9a1a86687512cf447c4d6921971dd6035f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e328fdbbefde56e425787e6da8af24fad4fd24940cac15f29bec3ca7e2e86b5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6007b3befe363755bbe0fc6dca52094ddd82c5f4ad7797c138d7a90f2b5cb78d"
    sha256 cellar: :any_skip_relocation, sonoma:        "26ae43820bdd04647b5e00c5ee523dfbf9501f687a72ab36d0ef7a8f9a01f037"
    sha256 cellar: :any_skip_relocation, ventura:       "f1bb2d24ddbc466efda8549d2fe7e18a804a8bb9a748a21ffcdcc97de4338382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7576abefe5dbfdc723818cc6af30da69dcfc43c6bc289d7822e099ec286226fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "505438fcdf732dd75bc28e707b5d5d665fba2c11d1ec488872f7c54b2a5e939c"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "perl"

  def install
    args = %w[
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DCMAKE_INSTALL_BINDIR=bin
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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