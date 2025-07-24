class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "b7c5a91551ee067932a237ce6fdb5293d34d621e7e4b49f3974080b91be50bc2"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f651ba30e9af80c970fa41a2c259f826d8a4e8fa58f67ec5282b3fdb21e4666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6969ec1ea9f6ffea3ebf3fb0a1d857507eb3e99e16cf590e6643d588ba449132"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "798f29763eb3cd66ec00ad058552fef7e2626e5cfb38f8735d3d488bb2e9e3b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "41e3367b074c744a0776da5ce2c643a324bde03c974228e1cb91cdfa24d37956"
    sha256 cellar: :any_skip_relocation, ventura:       "1b03e7e55b68bfc43324ce79d4e84f9dd561b81e934a6a0a9d6df154a2ec0404"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de7b403b5553796156a5361f96f0a53360fdfd2970dd686210f0c068d2713250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "778c493989a5539f7588c3cea74f644ffc0d7b00b8c42da0ce2d577c3e280e71"
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