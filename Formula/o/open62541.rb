class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https:open62541.org"
  url "https:github.comopen62541open62541archiverefstagsv1.4.3.tar.gz"
  sha256 "7e7091285221a0b686a08780efb84026cf5728e5b4c59febe230fe77b6d03475"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c4f02c5defa581d0e10f1a486b7147102cfa71261cff0a290495e1992401059"
    sha256 cellar: :any,                 arm64_ventura:  "9f0f09832bc1c2d4edce7d7fd294430efbe5e6c3b0913a6ef6a9b0bc5466d54f"
    sha256 cellar: :any,                 arm64_monterey: "17865c257c7fbfcaf56c686a2c285b32d52ffeabff9c32c6938336b904a8af80"
    sha256 cellar: :any,                 sonoma:         "8aa5f75500b5c4ab1f1b3d9c4a94e55bf0fb7220844a70ca92df8078adaee474"
    sha256 cellar: :any,                 ventura:        "03dee3e516a3d39c9a46b6d391b9d84b968ea4ae32c5e72deac8b8323a6fc596"
    sha256 cellar: :any,                 monterey:       "7e4fe5f13cd14620630489be7c8bb6c3e3e9381178f7728b5f988801abf88e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9067e17db5b99d3804fb17b7cdde7bcacab15b8ddfb3dfda86cdbfb321b62f0"
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
    (testpath"test.c").write <<~EOS
      #include <open62541client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    EOS
    system ENV.cc, ".test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system ".test"
  end
end