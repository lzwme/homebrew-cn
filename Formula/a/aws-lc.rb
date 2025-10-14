class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "731b740179ad5ab4222ad63d422ff19b2168f6a0f9d892bf40b41083a328f839"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e543b298fb9c95c06b0a9402bfe05b1545bb1267cd556e5512912dba464a247e"
    sha256 cellar: :any,                 arm64_sequoia: "5e573bb6b98f6974c17a5299a0426cb7c512013b949a29539d55374aacca5e48"
    sha256 cellar: :any,                 arm64_sonoma:  "61eba42043941172f0f987707d44ad9f931c212a5bcb0d95610a7452b8d9019b"
    sha256 cellar: :any,                 sonoma:        "560a3b30d5cbaa57e4741baf7d99e7ec342d7979e30c2f2c63d98479abdd8c39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9de531bb5fdfc68c1e2dd2944d286113d1a28a104f1f76be21e7baf413b9d6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e669d0cb8f1361502f7c3f0e9c7f3909ab87b03240268c66ec5aa31b703f8ea"
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