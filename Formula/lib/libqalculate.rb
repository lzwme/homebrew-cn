class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://ghfast.top/https://github.com/Qalculate/libqalculate/releases/download/v5.13.0/libqalculate-5.13.0.tar.gz"
  sha256 "e81dce6d9c44fa70e9f928b78e616ea352099c03aeee735aa0375789937e6231"
  license "GPL-2.0-or-later"

  bottle do
    sha256               arm64_golden_gate: "831c8899dae768d2a0997125921c94c0f537db0f422d105b4f20060458c0f1d4"
    sha256               arm64_tahoe:       "fe00c57938976f0baac6b4a8aebf56f04f836aba6ae95af64d979533e25ac769"
    sha256               arm64_sequoia:     "79e80e008b6b045afe10bfb80744cdc5f9500fc92a3bf92f0924acbff29c3688"
    sha256               arm64_linux:       "0e885ad9151b615604c6e7b658bce2f2ff07229efa572cc926093f5c1bbd1528"
    sha256 cellar: :any, x86_64_linux:      "244fd81e469838d1aab1593f9c0eafd794587fcca67f5f661082a1bdcdf85870"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-silent-rules",
                          "--without-icu",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end