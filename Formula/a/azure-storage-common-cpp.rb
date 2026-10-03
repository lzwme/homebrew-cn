class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://ghfast.top/https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.15.0.tar.gz"
  sha256 "23a10c84418f6d8c07858277f3b8e7c7344008f1ab9eacabdc485fb0744903e5"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b00c8981cc471073c6ac58d8d317a8b5481fe912c2b1e0c0fbcf9fbe286a0a83"
    sha256 cellar: :any, arm64_tahoe:       "85b6b625b71b845bb2c68e92eb2ad06687e66ca3082ae49f1440b68fe4fc1fe3"
    sha256 cellar: :any, arm64_sequoia:     "5dd98d8e82ae42a430e98878c051c47a73aebf7fa1b3c3e341e7b672748cb19b"
    sha256 cellar: :any, arm64_linux:       "8f9deafa3bf1f37aa9f499a936dc9deda66c94ef2e7d1066282d83935ebd268c"
    sha256 cellar: :any, x86_64_linux:      "dff335fbf74d89c4921b389dcf7603a2b6109225e6b517aaf8d16a6e7d01a8ef"
  end

  depends_on "cmake" => :build
  depends_on "azure-core-cpp"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    ENV["AZURE_SDK_DISABLE_AUTO_VCPKG"] = "1"
    system "cmake", "-S", "sdk/storage/azure-storage-common", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # From https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/storage/azure-storage-common/test/ut/crypt_functions_test.cpp
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <string>
      #include <vector>
      #include <azure/storage/common/crypt.hpp>

      static std::vector<uint8_t> ComputeHash(const std::string& data) {
        const uint8_t* ptr = reinterpret_cast<const uint8_t*>(data.data());
        Azure::Storage::Crc64Hash instance;
        return instance.Final(ptr, data.length());
      }

      int main() {
        assert(Azure::Core::Convert::Base64Encode(ComputeHash("Hello Azure!")) == "DtjZpL9/o8c=");
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-L#{lib}", "-lazure-storage-common",
                    "-L#{formula_opt_lib("azure-core-cpp")}", "-lazure-core"
    system "./test"
  end
end