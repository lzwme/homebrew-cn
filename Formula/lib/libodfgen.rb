class Libodfgen < Formula
  desc "ODF export library for projects using librevenge"
  homepage "https://sourceforge.net/p/libwpd/wiki/libodfgen/"
  url "https://dev-www.libreoffice.org/src/libodfgen-0.1.8.tar.xz"
  mirror "https://downloads.sourceforge.net/project/libwpd/libodfgen/libodfgen-0.1.8/libodfgen-0.1.8.tar.xz"
  sha256 "55200027fd46623b9bdddd38d275e7452d1b0ff8aeddcad6f9ae6dc25f610625"
  license any_of: ["MPL-2.0", "LGPL-2.1-or-later"]

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libodfgen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7f42c8f3db9efee29ccd3acfdbb58e401cff658eb20c77284acdcd1220770249"
    sha256 cellar: :any,                 arm64_sonoma:   "f8c8b108ac222308245eef3d268c4eeeb84b2a73f2410c45568f304a142471e0"
    sha256 cellar: :any,                 arm64_ventura:  "ee37bbec363199abddeafcd3c185add551b115ccbcf2d175be4e3372321be7dc"
    sha256 cellar: :any,                 arm64_monterey: "ba4d7f22c5590a4190cb043deb158860d752c6b517463deffbcf047f11b4abdf"
    sha256 cellar: :any,                 arm64_big_sur:  "db9ec11161a89cadc0cc829f021fbb1a26ffd96ca7962788013b6a83efa35440"
    sha256 cellar: :any,                 sonoma:         "2a36cb4f5ecfbab471f7523e46df2b4ed8a58502aeb8fc5fb5af4bdbe323f212"
    sha256 cellar: :any,                 ventura:        "8b8f072bab3214d7d530d36dd8e2fbc124a47e645a94521e3a469c9d65f9e84f"
    sha256 cellar: :any,                 monterey:       "0ed30ea41cd3a9fbfe33a02c48e2b7386a430d5bee931e04b1bec3113670cceb"
    sha256 cellar: :any,                 big_sur:        "f53270e1f9060d1e2074a89444899e540e3307270fbd94c6a5186e9a05ecda45"
    sha256 cellar: :any,                 catalina:       "f019ef9174156093d5592556fac3fb5e87a38a90882572a3ff4a15b7d9227c8c"
    sha256 cellar: :any,                 mojave:         "b8bcc9b962fa97d431fb4a27a924a18b37b264e43bb5e881b67668aa18633edd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bd214b5c11aff4b9a57155479ada4e47e8b0e75e4a523836682c6616719b6431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8466ec0a88ee4d205fb5bac977d257b7cea7c4dfcdcfc1028d97e4be5529c848"
  end

  depends_on "pkgconf" => :build
  depends_on "librevenge"

  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-static",
                          "--disable-test",
                          "--disable-werror",
                          "--without-docs",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libodfgen/OdfDocumentHandler.hxx>
      int main() {
        return ODF_FLAT_XML;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{include}/libodfgen-0.1",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-L#{lib}", "-lodfgen-0.1",
                    "-L#{Formula["librevenge"].lib}", "-lrevenge-0.0"
    system "./test"
  end
end