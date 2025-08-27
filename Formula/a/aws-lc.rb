class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "fcc179ab0f7801b8416bf27cb16cfb8ee7dff78df364afdf432ba5eb50f42b22"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce884a36da03cdea0c4caaf1ea85122a984d40177e71cf56d71c9a0d5c98c7ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7d6e9867079474d2fffc8b9c93ce4cdf1797b71b984635402bf8a0717a1b012"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07c09860f5040a02a694bf4e9b14baa697ace441a7101b40fe1c6720bc509f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad43f387394f4db77fd5dc34108e2c9b7da35c36d3a30c8dcdcc4091b3676e6"
    sha256 cellar: :any_skip_relocation, ventura:       "751c15c5f65461e2d15b479109fe9c6c15268948bac3c628afe2fc811805e8ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5604f8d28393cff8a66cfef57e3ac11d0da81f3ded55ec955aff051b83cc8fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16b47844e40303cb841cb06f516faecc8a26510a6c0918e56b367b3affea159"
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