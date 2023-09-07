class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://ghproxy.com/https://github.com/open62541/open62541/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "d3f84f1e2632c15a3892dc6c89f0cd6b4137e990b8aef8fe245cd8e75fbb5388"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb5efb9d2efee6ad6ac498c7a97365851052453e165c87983af764188f434ef7"
    sha256 cellar: :any,                 arm64_monterey: "d16bbe52c0290fac18437c951044bc9a047301fd423f2fd80431b1eda5689ca7"
    sha256 cellar: :any,                 arm64_big_sur:  "98f0763874777c210b651d519314f9c0d0d67c5492ca5706fb95e888b198d0c4"
    sha256 cellar: :any,                 ventura:        "052fcf1c233d4920315a6add360c5418dd6f283ebfa47c8821955b5be178a57f"
    sha256 cellar: :any,                 monterey:       "cad7abe7f699e346203bd68f094e93bb543281ab129d1569342141d8191f86d5"
    sha256 cellar: :any,                 big_sur:        "185a6a4c113c4d66c8d9a7684a34f9da101d6136a699563ad7f87c65df52f01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37e8d4fad01bb105e1a79e42a1c5b05998dd83b6d7f8a6bdd33035a4ed86d4ab"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

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
    (testpath/"test.c").write <<~EOS
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    EOS
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end