class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://ghfast.top/https://github.com/aws/aws-lc/archive/refs/tags/v5.7.0.tar.gz"
  sha256 "9ce2bdeda9930b8eadf8bb0a1cbb924a6e6bbce116370aea3fa7109c26d3660e"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0ad8c0d7f4c23993bac464ac8e322cad47585ad936fcc12007947f889e465fca"
    sha256 cellar: :any, arm64_sequoia: "4223ee90d059de89e1720cf33ce90c9ee725442b7fd3d1d52ec99ea2d8adf676"
    sha256 cellar: :any, arm64_sonoma:  "eed6a1a1dd471121a5f6427ad8b4df2644cd82e99647c1f49a07d808b94243ae"
    sha256 cellar: :any, arm64_linux:   "62431f4a1ee2ef7ac71aa9a5e9c3273a0052b1283c66c8da67b2e3789e5b45c8"
    sha256 cellar: :any, x86_64_linux:  "e94f56f2dcc446fca09e02338b70a477a702ea75b51154ceb6df30360c4347ef"
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