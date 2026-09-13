class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://ghfast.top/https://github.com/Juniper/libxo/releases/download/2.1.0/libxo-2.1.0.tar.gz"
  sha256 "5b4208199e5a785a3b5d7ee07e31788f037cf9acd6951f959d252c1e1b93c50c"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_golden_gate: "b86ca3388c4a3eed5179117c8557edef4448618280d4e47f8e13911928582877"
    sha256 arm64_tahoe:       "33bda6fc222a38b83f8425e376c25935c53253687d4a479ebcf76dfe99ba9193"
    sha256 arm64_sequoia:     "eab5f1bf937d3250427ce79c5fe13e599d6b87f37190eb44fb7901a8fbbceb64"
    sha256 arm64_linux:       "c29d085c614a5f90f9a03ebc6c8999ff04e79cbcd1f820243f68b3bccfe9c933"
    sha256 x86_64_linux:      "66b6651c968f2264bad41def9222a5c7da9719b65914128c468aa71e9782f12b"
  end

  depends_on "byacc" => :build # the XPath parser needs byacc, not bison
  depends_on "libtool" => :build
  depends_on "gettext"

  # Only include `bsd/string.h` in the gettext test when configure found it
  patch do
    url "https://github.com/Juniper/libxo/commit/dc0017cb7cea89363a27721f6ab4593305167b61.patch?full_index=1"
    sha256 "37f0bf7e9e01a94f185dbd59af3785688eaf4267bf4b8a76d92b1cbe6cfc5413"
    type :unofficial
    resolves "https://github.com/Juniper/libxo/pull/119"
  end

  def install
    # Nothing uses libcrypto, but finding it adds -lcrypto to every link
    ENV["ac_cv_lib_crypto_MD5_Init"] = "no"

    # configure only looks for gettext in /usr, /opt/local and /usr/local
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gettext=#{formula_opt_prefix("gettext")}",
                          "--prefix=#{prefix}"

    # glibc 2.38+ has `strlcpy` but does not declare it, so libxo leaves it
    # undefined in `libxo.so`; resolve it at load time (keeping the `-ldl` the
    # Makefile sets). Not needed on macOS, where `strlcpy` is in libc.
    if OS.linux?
      system "make", "install", "LDFLAGS=-ldl -Wl,--allow-shlib-undefined"
    else
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end