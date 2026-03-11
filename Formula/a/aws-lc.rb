class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "533dd3f35639f44784c8ad9b73c279ec3959aba79c63b9726dd8066564b2058f"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2dae082c55a580eb82215dfd92575cab9a89d3b2a99983b328edff9693eed316"
    sha256 cellar: :any,                 arm64_sequoia: "b1d601bfc900b635a5af0589e380a4380adff4a812b4b0ebabdb4bdce1eb3dc1"
    sha256 cellar: :any,                 arm64_sonoma:  "88d52f091daae0cde2e61a0359fbd969160519317c20fb35a78091e17696ff1f"
    sha256 cellar: :any,                 sonoma:        "7e812438df0bf3eeb78f1d65b0de3bd226ee8ae44aacd5a2b4610d1176bdcfb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9e95e34cb59038c363f209c81d29f7edaf483067b14ed70511fbef7b5ede3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5cbc6b0d37b1c6c19b9f440a2f4feaa38559562f6d2d2520bf547f7158e79c"
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