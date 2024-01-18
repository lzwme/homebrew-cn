class Numactl < Formula
  desc "NUMA support for Linux"
  homepage "https:github.comnumactlnumactl"
  url "https:github.comnumactlnumactlreleasesdownloadv2.0.17numactl-2.0.17.tar.gz"
  sha256 "8824ddd529a6f935dc2670bba6f52fb0f605f9f48e1176f69d6b7e48aad8cb27"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", :public_domain, :cannot_represent]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d591e21a9468f545f4b59b68b6e53d5d1a2379ebd3dd38afd6c5d519070edce"
  end

  depends_on :linux

  def install
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <numa.h>
      int main() {
        if (numa_available() >= 0) {
          struct bitmask *mask = numa_allocate_nodemask();
          numa_free_nodemask(mask);
        }
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lnuma", "-o", "test"
    system ".test"
  end
end