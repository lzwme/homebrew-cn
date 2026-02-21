class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "992d9de1fc7b6135282f68d92bc6d352852e4b540c5e8f4b1a89c5f3905e7d0b"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4a00c0046b9e9e67afc76165365a419e4cadc8d771b3ecb0376718b766daa47"
    sha256 cellar: :any,                 arm64_sequoia: "7c932abf5b1f71abea945d84d97f33168ebf6984f5d649cc6411cb9e15651ad3"
    sha256 cellar: :any,                 arm64_sonoma:  "69e3c434205c2d8c5a71fce06670222fbb5cabc5656136725fb1c0f572b078c1"
    sha256 cellar: :any,                 sonoma:        "9c90aa69dba032f4e59b5005b6704fbf7d33651b23c7deee71739d859a1f7a54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aa24e24e8448ac34cb354f6fad9b93b1060b17a4d490d406e9a65071cba235b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d810cbc5209b48fd69bddd63d1578b2a27c1036432dbd778b27aa74c54aaa7c"
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