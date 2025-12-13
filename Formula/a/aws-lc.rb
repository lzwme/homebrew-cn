class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "21020d848ffb7db0df0954afbb79b3eb80c389ced5f5286060d9416dd428a486"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2545d1c0bac57d6675755be40ed0cb2cb18513f48627c731b6ea84b050d33a98"
    sha256 cellar: :any,                 arm64_sequoia: "d4756dac3d8706ee797c1af677771679392851ac1d40856be741fc31d178bfc2"
    sha256 cellar: :any,                 arm64_sonoma:  "14e4647e0b9b95cd1c98c4ab6d9af5d5adbf320282e867663ac914fd54d3594d"
    sha256 cellar: :any,                 sonoma:        "00cd498380092f3ce5bcf6077dc64e718b2c0ebd307a90f0eec5e7f684e7146a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22f765b7514923025dbefeb6ae0aec34fb31464cbf83c2c02955134bd9797b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576e2d99104d08f3f7f1e0f90a0e9450b3fad29b83cac7190c797e446efe192d"
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