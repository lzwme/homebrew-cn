class AzureStorageBlobsCpp < Formula
  desc "Microsoft Azure Storage Blobs SDK for C++"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-blobs"
  url "https://ghfast.top/https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-blobs_12.14.0.tar.gz"
  sha256 "5ebd63d6d5c22702b504efef1acf0265ceff90dcf96b9c1e52c418bbd7c5deb4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-storage-blobs[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "564d7bf972b669e27972a9240ba76fc2bdd79658d329773463dfdf665230c3e4"
    sha256 cellar: :any,                 arm64_sonoma:  "00fcdc4ae56a9279c11e4469e32557f69a45aabc0863ef8fc731b0168906baa7"
    sha256 cellar: :any,                 arm64_ventura: "dd42d3d99d76863870f826d61dae8df986fe9897dabf29ad242507f5b30d1dc4"
    sha256 cellar: :any,                 sonoma:        "9ab156e43691be968aa1d90d917572e4e620cd1f3d81a042471c9ee819e0e880"
    sha256 cellar: :any,                 ventura:       "ad85710ea408ae28e051137357d1bc2ee41c98fdd97aff6af10242286013c2bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93910e3dd086411d746dcc82032e9879c994c41863a33d4b881b84dec7ce3d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9830a9f4ebc09fb1ed4d04cc8b477358a15e0be25a14525080ba4c79c72011ab"
  end

  depends_on "cmake" => :build
  depends_on "azure-core-cpp"
  depends_on "azure-storage-common-cpp"

  def install
    ENV["AZURE_SDK_DISABLE_AUTO_VCPKG"] = "1"
    system "cmake", "-S", "sdk/storage/azure-storage-blobs", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # From https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/storage/azure-storage-blobs/test/ut/simplified_header_test.cpp
    (testpath/"test.cpp").write <<~CPP
      #include <azure/storage/blobs.hpp>

      int main() {
        Azure::Storage::Blobs::BlobServiceClient serviceClient("https://account.blob.core.windows.net");
        Azure::Storage::Blobs::BlobContainerClient containerClient(
            "https://account.blob.core.windows.net/container");
        Azure::Storage::Blobs::BlobClient blobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::BlockBlobClient blockBlobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::PageBlobClient pageBlobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::AppendBlobClient appendBlobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::BlobLeaseClient leaseClient(
            containerClient, Azure::Storage::Blobs::BlobLeaseClient::CreateUniqueLeaseId());

        Azure::Storage::Sas::BlobSasBuilder sasBuilder;

        Azure::Storage::StorageSharedKeyCredential keyCredential("account", "key");
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-L#{lib}", "-lazure-storage-blobs",
                    "-L#{Formula["azure-core-cpp"].opt_lib}", "-lazure-core"
    system "./test"
  end
end