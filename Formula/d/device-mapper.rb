class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https:sourceware.orgdm"
  url "https:sourceware.orggitlvm2.git",
      tag:      "v2_03_28",
      revision: "f87a6ad6d6f7cde0170fd479a45ee5b0a1c63d52"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(href=.*?;a=tag;.*?>Release (\d+(?:\.\d+)+)<i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0e9e3a6ed8b745338383e56a2cde2fd67190ff2006a666f8774df3941628000c"
  end

  depends_on "pkg-config" => :build
  depends_on "libaio"
  depends_on :linux

  def install
    # https:github.comNixOSnixpkgspull52597
    ENV.deparallelize
    system ".configure", "--disable-silent-rules", "--enable-pkgconfig", *std_configure_args
    system "make", "device-mapper"
    system "make", "install_device-mapper"
  end

  test do
    (testpath"test.c").write <<~C
      #include <libdevmapper.h>

      int main() {
        if (DM_STATS_REGIONS_ALL != UINT64_MAX)
          exit(1);
      }
    C
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ldevmapper", "test.c", "-o", "test"
    system testpath"test"
  end
end