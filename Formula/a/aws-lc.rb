class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "df29273da8d18b2fd73f620a32776bcfba4e33efa37f6abbe70dec6234392e77"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d16377487c7f6c62ab4dcd44e026e7d673051f2930780ba2fbbfd5c6472216e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d44100b0a537e21b080af92376dde97b41a35099b5cc95bae2ac3524e01d912f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b20662ba719f96ab55842ae523139847d757a0f282fea14700836fef620bca3"
    sha256 cellar: :any_skip_relocation, sonoma:        "474addbcafc083fa6005435ac9946025f460748b33362e1671ac8ec5dceae9e1"
    sha256 cellar: :any_skip_relocation, ventura:       "770374d3e53862e4e48b01a272b1abbd746d943ef8f6f6ef3078ef45b341efb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c9d27b89e840c037bfa45ab31a9013fb69370041645c3305a194b694deb3b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "571ac128137a288f5d19cbd66af5f8b1ae33bce1fe51d856ab2f584f7651f09f"
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