class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https:open62541.org"
  url "https:github.comopen62541open62541archiverefstagsv1.4.7.tar.gz"
  sha256 "598889ae4bdc468d39c5c961ba76c648747b64337a9d0c0ef07b032c4819dea8"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e5f3b1923957233d5a19913e9c2134aac8f3498e93eb18fae0347fd628d65e23"
    sha256 cellar: :any,                 arm64_sonoma:  "772dd628877ad7b272bd4a8d76be6a21f3534ec5548de2ba7e88f76542dd8f3e"
    sha256 cellar: :any,                 arm64_ventura: "705ff59290a04b82955ca34cbe21ae2b7e95648fa233ed2c244b887b37dd2655"
    sha256 cellar: :any,                 sonoma:        "009f802e847c7d398933f63c16a7794a506f3428e0ddf212181abcfe742fc7f1"
    sha256 cellar: :any,                 ventura:       "340d5778d5d9006bdc8ddc1b29a51fa88f608c7d7d1709ca2a96ed50bac17130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f11169f1da79325ebe620f672c1e57cbbfb2bceb05a017ada7dfa1f4c7b0ac6"
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
    (testpath"test.c").write <<~C
      #include <open62541client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    C
    system ENV.cc, ".test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system ".test"
  end
end