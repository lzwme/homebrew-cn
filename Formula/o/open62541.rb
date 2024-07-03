class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https:open62541.org"
  url "https:github.comopen62541open62541archiverefstagsv1.4.2.tar.gz"
  sha256 "0ea31fbe836db685946439db3f06ccb04be86d5914d88327e9f3d641ebe10739"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7ddec7b82490050f05134b3d3d6259437f3d67b59786dc05823821039747cca6"
    sha256 cellar: :any,                 arm64_ventura:  "900762aaede231856cace680c55d0c7d10e05e7a2983c0584dbb94b5b30dee8d"
    sha256 cellar: :any,                 arm64_monterey: "20589c5b479b71b8bebdaa8438b5f8b130988ac02343771048bdd1199c202e6f"
    sha256 cellar: :any,                 sonoma:         "672f8d184e572472e378b2722d52e9e4714aa6eb77df352625e1499d5b44b17c"
    sha256 cellar: :any,                 ventura:        "511fc93ac53c2c639d2477772671a0838bfe1897935560ca2a52b6a4650a0a40"
    sha256 cellar: :any,                 monterey:       "e784af2d4563be458b79ce09dca5e412d0d13eb118d49c265eb57ba5996ad350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7abeb70579999c7dad19f3b2f3c9b4baea1997c6ac93e7864be6f79b38cc6f76"
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