class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.0.2",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "548e71aeca30d57ccfecfdc29a1fd93defe9a3b45941d98690d3686f29c3affb"
    sha256 cellar: :any,                 arm64_sequoia: "bb8650ae6d8204e50866bf5a34e2dd70d67c43cc4a6e03b297800db7691c0214"
    sha256 cellar: :any,                 arm64_sonoma:  "fb0cc2b446505e2cd556db4d8639ffdf2fab506def59fd6f15e670f3415abe86"
    sha256 cellar: :any,                 sonoma:        "72b361d058f442f1d62dbd2ba55e0b45fc52a9590ab7a7edb681534497561ab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12b390d938260c66084706711051bd1c4d62d5fc41cf678d344097f75f0a1ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af9d6b403f475b022860875ecdba75abaa2e8af7f405b0fbff0fcc23c486c71"
  end

  depends_on "avro-c"
  depends_on "jansson"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <err.h>
      #include <stddef.h>
      #include <sys/types.h>
      #include <libserdes/serdes.h>

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
    system "./test"
  end
end