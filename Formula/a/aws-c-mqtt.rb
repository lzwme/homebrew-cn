class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "66e6b90f27703ebebf06d2c78abdfafb5ca158c17f0b4476e42e0c4b913f7fb3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6318476fef40ece4a35ad0729780374df9332419f7703cdadfde90cbd842397b"
    sha256 cellar: :any,                 arm64_sequoia: "1613a6523c0aa1a515d3be70a0465828519a61932c50faf0921dcc67290fdea3"
    sha256 cellar: :any,                 arm64_sonoma:  "7114d3a1af36a0f159f16b6601d83c8b43dfd8b7ef3b4ec553057482f6b5862a"
    sha256 cellar: :any,                 sonoma:        "52e09a41ea1d77131c60b1b54112e39a30f24f8249c6be4191470979b6d2a142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab016ef0fccd8f1f91080b96b478a2af576d84bdc627e38f788a056ae1fbde1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d2106a6ca70fd34eee45856d56e042a749575fe4a9105b141e2e109c90b4979"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-cal` and `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/allocator.h>
      #include <aws/mqtt/mqtt.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_mqtt_library_init(allocator);
        aws_mqtt_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-mqtt",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end