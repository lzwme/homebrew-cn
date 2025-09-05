class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "3a064651f2454c64b1435dbcc6e623faae35937816b37b0c99ffaf223879c166"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17ed254cd391e2967b90bcad40d2cef0e327c5e0599a3d0c4faa8937c2dec693"
    sha256 cellar: :any,                 arm64_sonoma:  "2a247323696ca112a71ca18424c92a78b582c6ee630b7bae77c99d2310e8b2da"
    sha256 cellar: :any,                 arm64_ventura: "c9cd7bab893a52e0229def2bce76c32e9b4177a4123e441174c2e596ef005aa1"
    sha256 cellar: :any,                 sonoma:        "ca5071d508d7fce3f1a5631c372ccbb0bef173120d049f289cb9c9bb42924483"
    sha256 cellar: :any,                 ventura:       "d307d7a4c508466aa5cd74423cc767918b05d43f2261f8088ac41066f20abdde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32b3e943541b31079753f738e8dd1f0e9c8a6e5f0ee333cff4f7d5dc1433776a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf13abf6f70b07e73c9f7ef928ab064b496b13ef65317f2490617ec399e80617"
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