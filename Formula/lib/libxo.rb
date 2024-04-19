class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https:juniper.github.iolibxolibxo-manual.html"
  url "https:github.comJuniperlibxoreleasesdownload1.7.3libxo-1.7.3.tar.gz"
  sha256 "4a4506ac0b65d8d96726e8b1c126df45196ffd2acf2de81ea7752988fb462497"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_sonoma:   "6f2979989d49621f6cec5a1ab08499bbd32d8f9705351f2c4bc4cd91a5454123"
    sha256 arm64_ventura:  "6aad31e4f412d28e22bfcb8f550b65ca64a9f3f377fe2dd20e1aa403bb31d5e1"
    sha256 arm64_monterey: "6e53e633f93e2dc1a9d38c96dad72c14a8bfa039bc7e08c1045db909979364b9"
    sha256 sonoma:         "4d3f5e9f62f7a6c4e1bf607a764bc2883dd5739957345cce4b3b15d599239eb7"
    sha256 ventura:        "386363862ad9b84c71c4f387f2b8585f6a23cbf90080c879423845b8f3d65f8f"
    sha256 monterey:       "fb2afec5970ed5d3bf71299ff63851675e94fe84ba9604fb050b0aa3acfca91b"
    sha256 x86_64_linux:   "b0b76b22afad4b171676b4484bfcdc8e9bf1de2ef748f95dcd1c609fab53fbaa"
  end

  depends_on "libtool" => :build

  def install
    system ".configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <libxoxo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system ".test"
  end
end