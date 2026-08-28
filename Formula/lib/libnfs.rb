class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://ghfast.top/https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-7.0.1.tar.gz"
  sha256 "ba62a2705f7100727b8ea37741e6bb6d5e2ff9ec61fee4d77360793eca5eddc2"
  license "LGPL-2.1-or-later"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f659050963b83166026d6543e11d45ca28926801682b037b1d8206a03c386011"
    sha256 cellar: :any, arm64_sequoia: "0bb7c6ef70ed90dd251fd9f77f272ae96d866c2da8eca6eba9c54d5aeec01205"
    sha256 cellar: :any, arm64_sonoma:  "3f885ad22d5f1bb1dc8f6cbdbe09d07d860af37fee65c9b6433e5d258171b8b8"
    sha256 cellar: :any, arm64_linux:   "9a5bd3b6e56e80168975d4c82b01029e6773162650ab6b90c394bbfc88664bb2"
    sha256 cellar: :any, x86_64_linux:  "6d786f910b87ea409598ca7666d10f41b5e2f5582f2389c2df6fe0a6a0ceab00"
  end

  depends_on "cmake" => :build
  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "cmake", "-S", ".", "-B", "build", "-DENABLE_DOCUMENTATION=ON", "-DENABLE_UTILS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "No URL specified", shell_output("#{bin}/nfs-ls 2>&1", 1)

    (testpath/"test.c").write <<~C
      #if defined(__linux__)
      # include <sys/time.h>
      #endif
      #include <stddef.h>
      #include <nfsc/libnfs.h>

      int main(void)
      {
        int result = 1;
        struct nfs_context *nfs = NULL;
        nfs = nfs_init_context();

        if (nfs != NULL) {
            result = 0;
            nfs_destroy_context(nfs);
        }

        return result;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lnfs", "-o", "test"
    system "./test"
  end
end