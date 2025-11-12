class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.64.0.tar.gz"
  sha256 "54646e5956f5394473ebe32741d2bf1509f2b556424899aed116647856f1e041"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ffbd4217f66b62a6b481688e7dc6d1f63663a20fff0457fca2da0658779a20b9"
    sha256 cellar: :any,                 arm64_sequoia: "4a919e1890a04c892448f430344b0260e00dbe8a95931f994055a50914abefde"
    sha256 cellar: :any,                 arm64_sonoma:  "d89a44af96fe945e174ac44a4bd7cab4846bc8a9685179c2e9062b38990b221d"
    sha256 cellar: :any,                 sonoma:        "e7717dd349d0ed787a8411a14d43f247f651bfa714cb4b03bdbc836dcdd3000c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90d26422609fa711f69a1a076d577dbe4139d2e6da8005b494b813505f286cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca3ddf982915625127b1d0965c8ec416e1b7e9b0dcf5f84313cc0f985149dff2"
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