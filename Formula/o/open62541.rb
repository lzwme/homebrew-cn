class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://ghfast.top/https://github.com/open62541/open62541/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "b7d92fe4b767aac2935ffb7bff9c88d528ce8a05a3767d093748f14388622636"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "802291f9ba3a7d016466388b458decd2999a987064d58ede573b5636f8f2c3ea"
    sha256 cellar: :any,                 arm64_sequoia: "6774f2358c2f7ee80605827cceca64b8a2a8b768fdacbbe3fb5ed1ed42b8adaf"
    sha256 cellar: :any,                 arm64_sonoma:  "6fc1b0ad44aeab5cdc5820ef123c8a02852e8f38be1ad9af8ef11a7201d3b061"
    sha256 cellar: :any,                 sonoma:        "c21cf490276b1a5b23d034ae2f8a6ac49c2d7f6e502d45a93bfe90ae09cde57e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed46486841b611d4497c8fc1eff0ef32170430b1cdfaeea389c7f9e95baa1598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9255b103ca99c7d78743fbd9ee75b583ae21f16aa9cf3a8b055a2731c22a723b"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUA_ENABLE_DISCOVERY=ON
      -DUA_ENABLE_HISTORIZING=ON
      -DUA_ENABLE_JSON_ENCODING=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    C
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end