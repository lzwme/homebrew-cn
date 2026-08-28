class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v5.6.0.tar.gz"
  sha256 "2348c404dcb1166c09034aceb840bef21af440ae469cbc994f11ab57dd043d26"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bfd29b7e99f4e64d27f5d8e9e0d22284689852e4e21db6e01a7005b8f55e249b"
    sha256 cellar: :any, arm64_sequoia: "2e84d57a5b9018106e956cf80493dc9ecba3c336f11b5cabdb88a2ba43eb49bb"
    sha256 cellar: :any, arm64_sonoma:  "7de0c7237d25a5b64da6b52bbf3f88437517fd4f6a37fc267eccb2f2d865d6f6"
    sha256 cellar: :any, arm64_linux:   "e87dea77667b5a8ecb68e03687c8417b47c45c539892404fd285028014d67596"
    sha256 cellar: :any, x86_64_linux:  "50d11ea4f7a2f0d7062111dbb8d52656ebb514559c55419af40a156e004a54d6"
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