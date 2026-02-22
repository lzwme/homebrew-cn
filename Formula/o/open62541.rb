class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://ghfast.top/https://github.com/open62541/open62541/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "61110a51c4f00a70a6e47882ea92550b667eede62e66c64431fdc37ff660361c"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "862ec700c9dad58ae068dc6e5dea456952b4a46ed57fd1e49ef12b0e8513ae45"
    sha256 cellar: :any,                 arm64_sequoia: "4c13d352d37e7f5fdf6c7e4d36b6eaa0b3ddabeae3ec3e3ee598507d0212bc7a"
    sha256 cellar: :any,                 arm64_sonoma:  "f7fff78f07c80fd152c1becef7d81b5988445e02f20748bd8b6c810c6579930e"
    sha256 cellar: :any,                 sonoma:        "4ff42c6a421287b4216d35f7a1ea54e111e2419e16b99cf23e875128e834fb54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faa0cb5f57982d5f6e6439de7bd690c881325af59ae67b98bc9b559e0a7c5f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f6c54ee337fecee8ad6195c0b80d12382c86abbb1c4de268fb84f7214807871"
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