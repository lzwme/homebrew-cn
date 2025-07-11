class Mspdebug < Formula
  desc "Debugger for use with MSP430 MCUs"
  homepage "https://dlbeer.co.nz/mspdebug/"
  url "https://ghfast.top/https://github.com/dlbeer/mspdebug/archive/refs/tags/v0.25.tar.gz"
  sha256 "347b5ae5d0ab0cddb54363b72abe482f9f5d6aedb8f230048de0ded28b7d1503"
  license "GPL-2.0-or-later"
  head "https://github.com/dlbeer/mspdebug.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_sequoia:  "fffb3b1ca1b99e0186d8a36fa847918c4e533a935df4520a690ec285cdc16df3"
    sha256                               arm64_sonoma:   "b2afc19ddfc781ba82c0a1ec660cd0484285f4341bef4123f56c19b8e99c66c7"
    sha256                               arm64_ventura:  "56080d64e000643c6725ed8051485e0b85e8e5e386f7a57398a3ec06d59a699a"
    sha256                               arm64_monterey: "42af25df066a3e948b0644670299949b54582bdede0ab53e41dcb346c0c2c92e"
    sha256                               arm64_big_sur:  "2c4c83e755286f97432ced3adb0e81a15e2241715e82135a6cc758999d621cfd"
    sha256                               sonoma:         "3ca296dd7aca7d6a828126dc830dfe8fa917c38a2a953a09a662d155ba741527"
    sha256                               ventura:        "bdff1006fe15553254c8cdafce3c56689d2d59f7d6943b8cdac964e1b5d0f0b8"
    sha256                               monterey:       "161469d0a1065aa833dede6bb5b10f2caebecb397ea5af306ee64b4d8c71f937"
    sha256                               big_sur:        "bd15ded651cbe43d819ae5f6a52d90cfafd51306d42a2f2b6c98d1b70ed4873f"
    sha256                               catalina:       "4e512b296b8a655fbe8632afca020866f6499c461fb715aef5c4eb6bdda88034"
    sha256                               mojave:         "4d5d8c35966a0000b010bbaea7c2c403ff4921d1306d34d752ccceb3f3d3b155"
    sha256                               high_sierra:    "4124d4fbd9e191d941153962bb74aed50cc200c473b5ad5850610a1bc85f87b4"
    sha256                               sierra:         "e16447e04c99d74b8cdc49a063c230c64d09e34402d0221542594f3aacac5940"
    sha256                               el_capitan:     "22fc92bc5a594451eb0d0b943bce812619302c795fdad0ca4305c059ccf10a88"
    sha256                               arm64_linux:    "c1b911028aeb60adacec4ed8f289bc22d8a5108c4d59a8ea6c99bd2aab79c13d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "591e9d4d6bf5cedceda3db088a416b6c597acdcd65d40856c8f5fd69c49b8c7c"
  end

  depends_on "hidapi"
  depends_on "libusb-compat"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["hidapi"].opt_include}/hidapi"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      You may need to install a kernel extension if you're having trouble with
      RF2500-like devices such as the TI Launchpad:
        https://dlbeer.co.nz/mspdebug/faq.html#rf2500_osx
    EOS
  end

  test do
    system bin/"mspdebug", "--help"
  end
end