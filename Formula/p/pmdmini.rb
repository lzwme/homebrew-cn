class Pmdmini < Formula
  desc "Plays music in PC-8898 PMD chiptune format"
  homepage "https:github.commistydemeopmdmini"
  url "https:github.commistydemeopmdminiarchiverefstagsv2.0.0.tar.gz"
  sha256 "e3288dcf356e83ef4ad48cde44fcb703ca9ce478b9fcac1b44bd9d2d84bf2ba3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d3d140be8d8be65eaa695bb6e2b83964e989e141cfdd7ab8d2c9e05d81b55f54"
    sha256 cellar: :any,                 arm64_sonoma:   "a7f473c3f27a8a2e781391b383060545cfd8af27425b2c5eca4e18a2821ee2ff"
    sha256 cellar: :any,                 arm64_ventura:  "40b0b5792363acec17804091d52164083487b90a027f4fe2bdf05ca5a7045ba6"
    sha256 cellar: :any,                 arm64_monterey: "27137c3e0caeb62401f16ff188ab94c629935342615a97be38e2a12e77877f33"
    sha256 cellar: :any,                 arm64_big_sur:  "a2c9ff100327daa46dae7c0fb7d49ee5dd71f7dbd28d585d6a8f6f74b3c2db92"
    sha256 cellar: :any,                 sonoma:         "6512a8514b45e27bd01920299f9cc0678fa6728a2cf29c8e8f4595448e01ff58"
    sha256 cellar: :any,                 ventura:        "1579283d159ce1e4a6cc100211eb926a463401e0cdee4ebf314008c478c14c09"
    sha256 cellar: :any,                 monterey:       "b84f6ad8b040a1b193b753e8d9934045d605b7ba37a547acab95302aea802a77"
    sha256 cellar: :any,                 big_sur:        "149cbae3b8b5b93ad8b5e55590e87b96120aa5c4fa729f142d2ab62ea3758d4a"
    sha256 cellar: :any,                 catalina:       "32eaf2e42986d019c891e922a4c6744abdc243c7d927210f65a26c4b363aa569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d7b0addf0328bbb2bd4ab80af954ce4feaa11d57fb76aecc21da90b522cf9e"
  end

  depends_on "sdl2"

  resource "test_song" do
    url "https:ftp.modland.compubmodulesPMDShiori%20UenoHis%20Name%20Is%20Diamonddd06.m"
    sha256 "36be8cfbb1d3556554447c0f77a02a319a88d8c7a47f9b7a3578d4a21ac85510"
  end

  # Add missing include
  # Upstreamed here: https:github.commistydemeopmdminipull3
  patch :DATA

  def install
    # Add -fPIC on Linux
    # Upstreamed here: https:github.commistydemeopmdminipull3
    inreplace "makgeneral.mak", "CFLAGS = -O2", "CFLAGS = -fPIC -O2 -fpermissive"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}", "LD=#{ENV.cxx}"

    # Makefile doesn't build a dylib
    flags = if OS.mac?
      ["-dynamiclib",
       "-install_name", "#{lib}libpmdmini.dylib",
       "-undefined", "dynamic_lookup"]
    else
      ["-shared"]
    end

    system ENV.cxx, *flags, "-o", shared_library("libpmdmini"), *Dir["obj*.o"]

    bin.install "pmdplay"
    lib.install "libpmdmini.a", shared_library("libpmdmini")
    (include"libpmdmini").install Dir["src*.h"]
    (include"libpmdminipmdwin").install Dir["srcpmdwin*.h"]
  end

  test do
    resource("test_song").stage testpath
    (testpath"pmdtest.c").write <<~C
      #include <stdio.h>
      #include "libpmdminipmdmini.h"

      int main(int argc, char** argv)
      {
          char title[1024];
          pmd_init();
          pmd_play(argv[1], argv[2]);
          pmd_get_title(title);
          printf("%s\\n", title);
      }
    C
    system ENV.cc, "pmdtest.c", "-L#{lib}", "-lpmdmini", "-o", "pmdtest"
    result = `#{testpath}pmdtest #{testpath}dd06.m #{testpath}`.chomp
    assert_equal "mus #06", result
  end
end

__END__
diff --git asdlplay.c bsdlplay.c
index 14c721e..1338cf9 100644
--- asdlplay.c
+++ bsdlplay.c
@@ -1,3 +1,4 @@
+#include <signal.h>
 #include <stdio.h>
 #include <SDL.h>