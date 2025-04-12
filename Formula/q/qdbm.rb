class Qdbm < Formula
  desc "Library of routines for managing a database"
  homepage "https://dbmx.net/qdbm/"
  url "https://dbmx.net/qdbm/qdbm-1.8.78.tar.gz"
  sha256 "b466fe730d751e4bfc5900d1f37b0fb955f2826ac456e70012785e012cdcb73e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?qdbm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "9545986c17185d13f69ec77c0b22ccea11c26764720aedbb00d2d2b673a47be9"
    sha256 cellar: :any,                 arm64_sonoma:   "fb9f9c8620e37ed0dfbbf506adb5c634d3055b503328019eea53afde01547ead"
    sha256 cellar: :any,                 arm64_ventura:  "e6948ebb305c814ce996e7f26c20eed87531667acb01cfd47888ff002c89d324"
    sha256 cellar: :any,                 arm64_monterey: "81801d3db8db3a73c8421819684eddd73b84c385c5e0005a9a572de5faf654a9"
    sha256 cellar: :any,                 arm64_big_sur:  "5b0f851a602c8cb4f0fab49204037f7a6d28bc311a30559c7f08c37c36b66add"
    sha256 cellar: :any,                 sonoma:         "cc13e898b5702e4412a1ec4c2b66ac4cf46d1072a15c7f7cd2d60a2a35544e78"
    sha256 cellar: :any,                 ventura:        "a94916c4050a878f94976c479fe1ccc042292676f1abe11f76c2b12f92851b1c"
    sha256 cellar: :any,                 monterey:       "f14f954b9e525de06afbb324b22df63af903f814ff81c5f2ecf787f9d9a2963f"
    sha256 cellar: :any,                 big_sur:        "7257a9e22ee3661fc2213d5ff60148b44e5e217781a3af807405c239020b3c6a"
    sha256 cellar: :any,                 catalina:       "0a0ba32270742fbd821ba60bbc6452e6b6b6a476d72e719bdb33fdf535e316f0"
    sha256 cellar: :any,                 mojave:         "4861035c21a7fcd02efca60c922d06a45f3078eaffa374784a533932f9efa806"
    sha256 cellar: :any,                 high_sierra:    "4ec4e60b16efb21fd7835c182fcf5d8f43c4af4329dd8afb07b4900bc1b17f60"
    sha256 cellar: :any,                 sierra:         "547ecf82252706d276c8359448b7f4e738264999028b06cd3738af34ba58276c"
    sha256 cellar: :any,                 el_capitan:     "6fd80b953a53cdf048bf686d2ac3620deda19a022a10a1e7cbd7aea073bf9b6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4ae8fe86435b3471721692361be9749e98955ad4d13b757ecf0dc777c112ae19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52780796d139d8e46d0bb342f4e8cce314fa587fee9932a897626b3a1b58a481"
  end

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --enable-zlib
      --enable-iconv
    ]

    if OS.mac?
      # Does not want to build on Linux
      args << "--enable-bzip"
    else
      ENV.append "LDFLAGS", "-L#{Formula["zlib"].opt_lib}"
    end

    system "./configure", *args
    if OS.mac?
      system "make", "mac"
      system "make", "install-mac"
    else
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <depot.h>
      #include <stdlib.h>
      #include <stdio.h>

      #define NAME     "mike"
      #define NUMBER   "00-12-34-56"
      #define DBNAME   "book"

      int main(void) {
        DEPOT *depot;
        char *val;

        if(!(depot = dpopen(DBNAME, DP_OWRITER | DP_OCREAT, -1))) { return 1; }
        if(!dpput(depot, NAME, -1, NUMBER, -1, DP_DOVER)) { return 1; }
        if(!(val = dpget(depot, NAME, -1, 0, -1, NULL))) { return 1; }

        printf("%s, %s\\n", NAME, val);
        free(val);

        if(!dpclose(depot)) { return 1; }

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lqdbm", "-o", "test"
    assert_equal "mike, 00-12-34-56", shell_output("./test").chomp
  end
end