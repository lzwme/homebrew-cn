class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.62.1.tar.gz"
  sha256 "e79ff780fbe5a8e8d9f945dea54c274e6ebcab1c2c710b79b02fd32780db6fd3"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f82c7a4e5bf48e60a56fcec982dc22929db416b658f234c573027723bcf9de50"
    sha256 cellar: :any,                 arm64_sequoia: "c89254ceddc81437f1e4d28e046f3317e63fa8a4ad4dea5e7a50d7fc4db4536e"
    sha256 cellar: :any,                 arm64_sonoma:  "51c3eb96e5aca42f05956a149bc1d7b6e2aa27d519202988ab32ddca6ea9e66f"
    sha256 cellar: :any,                 sonoma:        "e5d0ced680f91602880a06aa2b5a76d0bd242e7ae3ef322823ebbf313199c345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a979c661f30ab9daa258bb90144e721b79edf3421fa6d6c90577fca4d0f2bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7da7b42ea31558af1037067d0f8223b37653d591fb6a23c2719a930c7106d21"
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