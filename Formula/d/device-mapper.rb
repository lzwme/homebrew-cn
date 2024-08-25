class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https:sourceware.orgdm"
  url "https:sourceware.orggitlvm2.git",
      tag:      "v2_03_26",
      revision: "6de3937ac517a3ecfd6d8d90f3f055dab631157e"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(href=.*?;a=tag;.*?>Release (\d+(?:\.\d+)+)<i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "03c0877e55b18953dcb009d0ecfff17425a0eabd2077e452bad1b8b665237efb"
  end

  depends_on "libaio"
  depends_on :linux

  def install
    # https:github.comNixOSnixpkgspull52597
    ENV.deparallelize
    system ".configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-pkgconfig"
    system "make", "device-mapper"
    system "make", "install_device-mapper"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <libdevmapper.h>

      int main() {
        if (DM_STATS_REGIONS_ALL != UINT64_MAX)
          exit(1);
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ldevmapper", "test.c", "-o", "test"
    system testpath"test"
  end
end