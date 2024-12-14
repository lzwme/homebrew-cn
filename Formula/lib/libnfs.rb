class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https:github.comsahlberglibnfs"
  url "https:github.comsahlberglibnfsarchiverefstagslibnfs-6.0.1.tar.gz"
  sha256 "16c2f2f67c68e065304e42a9975e9238f773c53c3cd048574e83c6f8a9f445c3"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7dde222002bc32bffc79d59ef75f13f904c1704ea9cedb4caed9a427f60e115"
    sha256 cellar: :any,                 arm64_sonoma:  "3bd08fd8c27af6c0a48fc215feb89ba9879054b16b5f9dc465c5a99bc1f015ef"
    sha256 cellar: :any,                 arm64_ventura: "8981260780efb3ae005b7a8d873eea61c4d9c4a68939b66185ac3e997e87f36d"
    sha256 cellar: :any,                 sonoma:        "74330ab7704e64e960f637a725692b50fbd175fe5fab6e0845fd45d19bf6c0bd"
    sha256 cellar: :any,                 ventura:       "234d992e081fc292e7227e7c49b88ab45c9d18912df1d7831096b8dbce463649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a71129f89e6532aa5e969acd7603c58c77dd6c133d3a84b5242bea49bfb8d631"
  end

  depends_on "cmake" => :build
  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}xmlcatalog"

    system "cmake", "-S", ".", "-B", "build", "-DENABLE_DOCUMENTATION=ON", "-DENABLE_UTILS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "No URL specified", shell_output("#{bin}nfs-ls 2>&1", 1)

    (testpath"test.c").write <<~C
      #if defined(__linux__)
      # include <systime.h>
      #endif
      #include <stddef.h>
      #include <nfsclibnfs.h>

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
    system ".test"
  end
end