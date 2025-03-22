class Libserdes < Formula
  desc "Schema serdeserializer lib for Avro + Confluent Schema Registry"
  homepage "https:github.comconfluentinclibserdes"
  url "https:github.comconfluentinclibserdes.git",
      tag:      "v8.0.0",
      revision: "152fad7ddec001e886452726e71f3b6a5c8e8c65"
  license "Apache-2.0"
  head "https:github.comconfluentinclibserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9cb58d9f9f6a564d219bd9a76ccde9e11b22ccb07bbad4e62e2f22f4cd7baff1"
    sha256 cellar: :any,                 arm64_sonoma:   "a335b839fa4fb5d79f5008bd8a277e5579f250cfe6adb48abeec4aa4b4fd759a"
    sha256 cellar: :any,                 arm64_ventura:  "8121b5492ec3631fb454765e917e234010bb6c0d314b3783062aeeaf00950111"
    sha256 cellar: :any,                 arm64_monterey: "6496f4d41457a209c42b3221b91be84209a6b1fa25f1be8fba95f1398dbadfb5"
    sha256 cellar: :any,                 arm64_big_sur:  "0c3c3421a41fb3faceaf574465cf7554ee61ddfca287dd669fef6cddbbc56a44"
    sha256 cellar: :any,                 sonoma:         "b046a45472a1095719a81a350865348265182e610032e4180caf070a669e481d"
    sha256 cellar: :any,                 ventura:        "42f216af7be083f8edca4b13888517bece78e4a46d16653ad752e04beb57fdfd"
    sha256 cellar: :any,                 monterey:       "a31419be0041dd57cef418fdce0a51c9c9af4aa00e0ca0faa40622b359c94a7d"
    sha256 cellar: :any,                 big_sur:        "86eb44c16b5a2f33da010ec7e13df64521270c7a43b8395646effe886254066a"
    sha256 cellar: :any,                 catalina:       "6530d6f15114bb1670201170b6e564415eb610072944609d6b2fa029329fd722"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0add5c36720048c77106dcab1dee9554a1d1993bf9416378364edba0272bdd08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc8f04a8a7f87996e1dc8f16ca51c16d07986352fdc1f46cb2c87e5fd73afdc5"
  end

  depends_on "avro-c"
  depends_on "jansson"

  uses_from_macos "curl"

  def install
    system ".configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <err.h>
      #include <stddef.h>
      #include <systypes.h>
      #include <libserdesserdes.h>

      int main()
      {
        char errstr[512];
        serdes_conf_t *sconf = serdes_conf_new(NULL, 0, NULL);
        serdes_t *serdes = serdes_new(sconf, errstr, sizeof(errstr));
        if (serdes == NULL) {
          errx(1, "constructing serdes: %s", errstr);
        }
        serdes_destroy(serdes);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lserdes", "-o", "test"
    system ".test"
  end
end