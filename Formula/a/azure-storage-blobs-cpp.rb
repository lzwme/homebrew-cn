class AzureStorageBlobsCpp < Formula
  desc "Microsoft Azure Storage Blobs SDK for C++"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-blobs"
  url "https://ghfast.top/https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-blobs_12.19.0.tar.gz"
  sha256 "346cf098f055b90b88b380ac08c3e31bfca1578e1186b85ba85be7b436c0ad63"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-storage-blobs[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7683ce2a6360b4c5f368db0d1d3663681900e07ab0824bbd1d3285f79173af50"
    sha256 cellar: :any, arm64_tahoe:       "f0f1d69bebc97d7ad46f8649ef51fa3e3c13f359ba1a092ac434e401f0e7d184"
    sha256 cellar: :any, arm64_sequoia:     "ae8694928960e7a29d6a4e188213ac2b3b3653156f636bdbe42cf391d80025ba"
    sha256 cellar: :any, arm64_linux:       "f229fa9481ba5e97f548afa7309f49ceca6caa44c39f46c3114992a03a682789"
    sha256 cellar: :any, x86_64_linux:      "3319971010161a977746ef7a7354e76e5ec97653f34f0ace790e222c5086df10"
  end

  depends_on "cmake" => :build
  depends_on "azure-core-cpp"
  depends_on "azure-storage-common-cpp"
  depends_on "flatcc"
  depends_on "nanoarrow"

  deny_network_access!

  def install
    ENV["AZURE_SDK_DISABLE_AUTO_VCPKG"] = "1"
    # TODO: Remove when upstream supports shared flatcc: https://github.com/Azure/azure-sdk-for-cpp/issues/7437
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DFLATCCRT_LIB_PATH_RELEASE=#{formula_opt_lib("flatcc")/shared_library("libflatccrt")}
    ]
    system "cmake", "-S", "sdk/storage/azure-storage-blobs", "-B", "build", *args, *std_cmake_args
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
                    "-L#{formula_opt_lib("azure-core-cpp")}", "-lazure-core"
    system "./test"
  end
end