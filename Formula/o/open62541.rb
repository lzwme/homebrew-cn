class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://ghfast.top/https://github.com/open62541/open62541/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "920a4c05a9b32862d38f60a70bc0972f29352fd55ba2393fa6bf49b14bcba222"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9922b71ea785d403f922f492a686bf3a164922559f4a2ea905325decd081c7a9"
    sha256 cellar: :any, arm64_sequoia: "1092c898edc761a73e9bdb5388edab495202b7a822ce16959155cd24bb0b8e59"
    sha256 cellar: :any, arm64_sonoma:  "17a0685edf5d042384a936d7d3dfd7bd2ba1a4a3c0156a9af03c01cd0804e7f4"
    sha256 cellar: :any, sonoma:        "afe85b6d4885cd6ae2b1abe65d9d9ace319376a6e6cfe68d3787ba3190fe6127"
    sha256 cellar: :any, arm64_linux:   "b354763f69935a64ff282eb7049bafe5f964b6260ce9180b8c31668503233a23"
    sha256 cellar: :any, x86_64_linux:  "764921977ddc942dc767f713133f2ff5fd099ac604f88c0c4198706a09484a4e"
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