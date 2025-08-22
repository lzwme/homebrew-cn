class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  sha256 "e4eee34cfa3d5838c08f20ac70f5b28239cb137bb59c75199f809141070620dd"
  license "Apache-2.0"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e17b813a73dafc0a88d4436a4744603800c8870903063514fca333015a7fc16f"
    sha256 cellar: :any,                 arm64_sonoma:  "5637122aa767f1c09b5ffdfa5e3bc369fffc912de7db35440a74ac97503fbb7c"
    sha256 cellar: :any,                 arm64_ventura: "dc2072aa142a8a4f21414bdace24121bddad5ac6667fc32b412f9ac0d2630837"
    sha256 cellar: :any,                 sonoma:        "5627ec90bc03294b80d60a042510795b9cc6bad0b3273eac96d247915aff09f2"
    sha256 cellar: :any,                 ventura:       "5758ca49c4efbd0b6f24fe5ca5321290e03e8557e02eb2050001d1a4dc1c23ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "452cc1e4ef67eb9f3b58f0d62ccb4ad90f5b8b4b9f5ee971a7d99c704f87fd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14127de62a4698ecbc3718c904786ae2bfc009c309d6c5bf10a86ad4d4454ec1"
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
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/93a4bb54004417c3742ca0e41183c662d9f417f5/libpulsar/asio.patch"
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