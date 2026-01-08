class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "bc23c419640ee513dc35881828d8df6221558329eb10b15b8aadae0ae61d5b0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6159bd18e028967275da6b6e98667b21fbaa6019f6ed666628c1ac8952b390c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90c9d5cf3d4227b719b038863b9fd0c18796ad6cd26458ba04c9b4afa2a7e298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bcaa0f2d38089c0eb4d5bc006d82f1163c782fbd49029fbb41b142a85a22dbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f616e2c2dd5446df3a68019aa3269fb548450bc0320a9cc248ba9c77bdebaf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9462a3ade7ff6c16ae54e1b35cbe279fda5d7ddaf497464d6cdaf410353bcdc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e4fe7cdaaf76edea7e95f6bc982ae05de9f481876f36e894ce15c8ee872d041"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/tools/shell/lbug"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbug --version")

    # Test basic query functionality
    output = pipe_output("#{bin}/lbug -m csv -s", "UNWIND [1, 2, 3, 4, 5] as i return i;")
    assert_match "i", output
    assert_match "1", output
    assert_match "2", output
    assert_match "3", output
    assert_match "4", output
    assert_match "5", output
  end
end