class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.63.0.tar.gz"
  sha256 "8cbfe34e49c9a8ab836a72173e8b919b12dc9605252f25c667358ddc3f2d9c6b"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a9289c48d87713dc6a924891d5c4755661f8de2ca81647ca162ecbf15e64d49"
    sha256 cellar: :any,                 arm64_sequoia: "683f7677dc1c2733920645b67a6832a8238c271c488cb81623c2cc877dc87299"
    sha256 cellar: :any,                 arm64_sonoma:  "acfad2d91e319f824481f990db52a2b50a6f29f5212d9a9f16341e0244f4fa60"
    sha256 cellar: :any,                 sonoma:        "960476b14bd2fa7e6604024ba35be8d7536d22f7b557b60ba58339c4c0525b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "682a5ce7aea14ce17253fcb9ebbb9fdce7ca672d5d01ff4d4199a8b1265603da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df90153d3138886e5c0c890561ef24b9df4f15dc1ca9c98f38dba177ccf7c7d6"
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