class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://ghfast.top/https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-7.0.2.tar.gz"
  sha256 "188a8a5de2ad2099a2e97e42f34721bfc4c16c8d33808de0f7484f99d714a3df"
  license "LGPL-2.1-or-later"
  compatibility_version 4

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "795251cbeab10dafae19cbd02104df2580aa30ab7ac03ca14fd2fbc6202bb0d3"
    sha256 cellar: :any, arm64_tahoe:       "9fd081f0367a73c582d30468286129807103158d8aa4c5ba02b7e94c236c4aa4"
    sha256 cellar: :any, arm64_sequoia:     "acc65a0b36fbbafbc99285bb30e719a9a5ebea20450cd9d1afdfd77a45e51605"
    sha256 cellar: :any, arm64_linux:       "bb3a47b0514d8f6558ffe5eda455e573689c1db992ebe138b4095bffff5ec14e"
    sha256 cellar: :any, x86_64_linux:      "bf4735873e9f72953d1d10a038feeabe72725a3f2cca1bca008b3360672cc619"
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