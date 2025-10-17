class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  sha256 "e4eee34cfa3d5838c08f20ac70f5b28239cb137bb59c75199f809141070620dd"
  license "Apache-2.0"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e09546097a2674bad598adaceb4bc28d0965ce4df69ce719a90f675508d9c70d"
    sha256 cellar: :any,                 arm64_sequoia: "40a6bd214f171f91ea59051b4bf44e2dc599e8090a8eb53eb7958e2e546beab0"
    sha256 cellar: :any,                 arm64_sonoma:  "e56bb469b5ba4cb4d74ef51a308eda1100f3297c08e33fff901c32eb0b48f0e3"
    sha256 cellar: :any,                 sonoma:        "e722feeca5fa95f757b21943f53fa58582e6685179b5ecd08c93661dd6a3a040"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2c9a37b5cebdc0588b6b6eedf6e9887b0d896957d7724f74c481649e8c88384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d7fd16c1151f644bc85cc842189749cba7ec2bec82d5757453dff8bbc5b5cc"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Backport of https://github.com/apache/pulsar-client-cpp/pull/477
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libpulsar/asio.patch"
    sha256 "519ecb20d3721575a916f45e7e0d382ae61de38ceaee23b53b97c7b4fcdbc019"
  end

  # Workaround for Protobuf 30+, issue ref: https://github.com/apache/pulsar-client-cpp/issues/478
  patch :DATA

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=OFF
    ]
    # Avoid over-linkage to `abseil`.
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:#{free_port}");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/lib/ProtobufNativeSchema.cc b/lib/ProtobufNativeSchema.cc
index 5cddf74..4bf45cf 100644
--- a/lib/ProtobufNativeSchema.cc
+++ b/lib/ProtobufNativeSchema.cc
@@ -39,8 +39,8 @@ SchemaInfo createProtobufNativeSchema(const google::protobuf::Descriptor* descri
     }

     const auto fileDescriptor = descriptor->file();
-    const std::string rootMessageTypeName = descriptor->full_name();
-    const std::string rootFileDescriptorName = fileDescriptor->name();
+    const std::string rootMessageTypeName = std::string(descriptor->full_name());
+    const std::string rootFileDescriptorName = std::string(fileDescriptor->name());

     FileDescriptorSet fileDescriptorSet;
     internalCollectFileDescriptors(fileDescriptor, fileDescriptorSet);