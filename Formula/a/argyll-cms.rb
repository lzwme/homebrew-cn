class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https:www.argyllcms.com"
  url "https:www.argyllcms.comArgyll_V3.2.0_src.zip"
  sha256 "ea554c48a1d36f8a089ac860cc5b4d00536b7511948aa2c4c4314e07be8b7bb8"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.argyllcms.comdownloadsrc.html"
    regex(href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zipi)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d5e4052a0f7158298a4af6fd524fce4059a7eb1cf0f19f5a4adaed944855999"
    sha256 cellar: :any,                 arm64_ventura:  "e0df2b999ec169b86890f74452ef3c3c2d1059808841b731d5189dbce52e7291"
    sha256 cellar: :any,                 arm64_monterey: "245b61b490d5fc436b63a2177838a85dc7937b5f4746af93c01ef9da3632c214"
    sha256 cellar: :any,                 sonoma:         "1c2725105fbdb8a7e02bfb6c7976fe4b3ce95065659b821288082593592a7a0c"
    sha256 cellar: :any,                 ventura:        "b4731bd37dcb1d1f5c3a8480ce3b405e7ab25f80b4c482e20b1b099bf22a3aec"
    sha256 cellar: :any,                 monterey:       "3e41eac2deb602c82bc1ff85b52b418591dd467b7fda6f89fee527d43e296fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "337a6f0583b0d6d19862bf432ba63cfa7f7551ae61e5dcdf026960b25edeea0e"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "xorgproto"
  end

  conflicts_with "num-utils", because: "both install `average` binaries"

  resource "jam" do
    # The "Jam Documentation" page has a banner stating:
    # "Perforce is no longer actively contributing to the Jam Open Source project.
    # The last Perforce release of Jam was version 2.6 in August of 2014. We will
    # keep the Perforce-controlled links and information posted here available
    # until further notice."

    # The argyll-cms maintainer told us that they want to keep jam as a build system
    # even if it is not maintained anymore
    # https:www.freelists.orgpostargyllcmsStatus-of-Jam-build,1
    # Vendoring jam will allow to get rid of our jam formula
    url "https:swarm.workshop.perforce.comdownloadsguestperforce_softwarejamjam-2.6.1.zip"
    sha256 "72ea48500ad3d61877f7212aa3d673eab2db28d77b874c5a0b9f88decf41cb73"

    # * Ensure <unistd.h> is included on macOS, fixing the following error:
    #   `make1.c:392:8: error: call to undeclared function 'unlink'`.
    # * Fix a typo that leads to an undeclared function error:
    #   `parse.c:102:20: error: call to undeclared function 'yylineno'`
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patchescf70f015e7398796660da57212ff0ab90c609acfjam2.6.1.patch"
      sha256 "1850cf53c4db0e05978d52b90763b519c00fa4f2fbd6fc2753200e49943821ec"
    end
  end

  # notified author about the patch
  patch :DATA

  def install
    resource("jam").stage do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LOCATE_TARGET=bin"
      libexec.install "binjam"
    end

    # Remove bundled libraries to prevent fallback
    %w[jpeg png tiff zlib].each { |l| (buildpathl).rmtree }

    inreplace "Jamtop" do |s|
      openssl = Formula["openssl@3"]
      libname = shared_library("lib$(lcase)")
      usr = if OS.mac?
        "#{MacOS.sdk_path_if_needed}usr"
      else
        "usr"
      end

      # These two inreplaces make sure all Homebrew and SDK libraries can be found by the Jamfile
      s.gsub! "[ GLOB usrinclude$(subd) : $(lcase).h $(lcase)lib.h ]",
              "[ GLOB #{openssl.opt_include}$(subd) : $(lcase).h $(lcase)lib.h ] || " \
              "[ GLOB #{HOMEBREW_PREFIX}include$(subd) : $(lcase).h $(lcase)lib.h ] || " \
              "[ GLOB #{usr}include$(subd) : $(lcase).h $(lcase)lib.h ]"
      s.gsub! "[ GLOB usrlib : lib$(lcase).so ]",
              "[ GLOB #{openssl.opt_lib} : #{libname} ] || " \
              "[ GLOB #{HOMEBREW_PREFIX}lib : #{libname} ] || " \
              "[ GLOB #{usr}lib : #{libname} lib$(lcase).tbd ]"

      # These two inreplaces make sure the X11 headers can be found on Linux.
      s.gsub! "usrX11R6include", HOMEBREW_PREFIX"include"
      s.gsub! "usrX11R6lib", HOMEBREW_PREFIX"lib"
    end

    ENV["NUMBER_OF_PROCESSORS"] = ENV.make_jobs.to_s
    inreplace "makeall.sh", "jam", libexec"jam"
    inreplace "makeinstall.sh", "jam", libexec"jam"
    system "sh", "makeall.sh"
    system ".makeinstall.sh"
    rm "binLicense.txt"
    prefix.install "bin", "ref", "doc"

    rm libexec"jam"
  end

  test do
    system bin"targen", "-d", "0", "test.ti1"
    system bin"printtarg", testpath"test.ti1"
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each do |f|
      assert_predicate testpathf, :exist?
    end

    # Skip this part of the test on Linux because it hangs due to lack of a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Calibrate a Display", shell_output("#{bin}dispcal 2>&1", 1)
  end
end

__END__
diff --git agamutGenRMGam.c bgamutGenRMGam.c
index 05e6bef..bac04ca 100644
--- agamutGenRMGam.c
+++ bgamutGenRMGam.c
@@ -12,6 +12,7 @@
 #include "aconfig.h"
 #include "numlib.h"
 #include "icc.h"
+#include "xicc.h"
 #include "cgats.h"
 #include "xcam.h"
 #include "gamut.h"