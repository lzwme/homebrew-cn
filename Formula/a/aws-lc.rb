class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.58.1.tar.gz"
  sha256 "ea35b5b8108fbf7e97cae8cad7fe63f15fb70cc3b079c5f83fba3b5bbab7edc4"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e187cffe195904ad23720525ec293d19ea6827f86cffdbc8f3d9d76de863637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62fbb235a3c00f0cd8d17b49cf71ac1bd9d03b2b7063b9d0718e553ab2d99f32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90eb39cbf98fa20d0d63cf5179b176f5c684f8d92e15729c3fa5c8236f56f726"
    sha256 cellar: :any_skip_relocation, sonoma:        "11df86f40dd67342b2f138a80948b6ad687f8bab76e0ba4b43e0e9d4e75021e3"
    sha256 cellar: :any_skip_relocation, ventura:       "c9df6af95017a9e2eecd425c582e1021b5988e9031bf81e977afac0dc6035d90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba15130ef7c83908bb6b08a1a40a90d0318c27cb48482a376b422c490f3aad9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "886e87231d31a192d02ae6f23aadff99d0dc5d7429539e5449cebe134d421452"
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