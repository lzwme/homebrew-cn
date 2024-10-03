class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https:open62541.org"
  url "https:github.comopen62541open62541archiverefstagsv1.4.5.tar.gz"
  sha256 "0112b7c348f2e6bab96ac03a0005f99fe5de872d7f54e44a75cfe3af2fa55b13"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c6c897eddc043405c61a799356ac4efda7e9ceb9bc9c6e30cac6f5503ecfea42"
    sha256 cellar: :any,                 arm64_sonoma:  "983ec2138b851569aebbf3089f14e320de8eeb74caae83df944feeae0bd7dc62"
    sha256 cellar: :any,                 arm64_ventura: "cb792ce7d2a71ee8a3120ab18d036b1aec7fc5f3c497ed018470fc9b7b1a066d"
    sha256 cellar: :any,                 sonoma:        "8b846f41a4b4ee97b73bf66db9cdb69928b07a13c8ec2091de9c4dbd5575f725"
    sha256 cellar: :any,                 ventura:       "bf9177233a2b689847691043d41b399db2b9d24784db491e72dcd9cfc9d71bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d88ab86cd136983365cf96b4962859cebd80ea4f5bcb24ed48d6591ffc600125"
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