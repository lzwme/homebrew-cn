class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https:www.wolfssl.com"
  # Git checkout automatically enables extra hardening flags
  # Ref: https:github.comwolfSSLwolfsslblobmasterm4ax_harden_compiler_flags.m4#L71
  url "https:github.comwolfSSLwolfssl.git",
      tag:      "v5.7.4-stable",
      revision: "bdd62314f00fca0e216bf8c963c8eeff6327e0cb"
  license "GPL-2.0-or-later"
  head "https:github.comwolfSSLwolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+)[._-]stablei)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0b4b4477caa3db76cac87f4cedeb5e33595d64301f6ae581c017551f684f333"
    sha256 cellar: :any,                 arm64_sonoma:  "203cfe671001a5c5dcea8fe9b8b56c362da1368067ae37591866fc87c864fabd"
    sha256 cellar: :any,                 arm64_ventura: "039f074f6784d380e4f3f1734be5276c4a466a63757154a5b1512cf0aefa8ad5"
    sha256 cellar: :any,                 sonoma:        "c8c8740772a0e25fde64d6bd40d1a21112a82389b79c6730d5bfc707db590735"
    sha256 cellar: :any,                 ventura:       "5375a3fb86be4efcfe002c1a8ba73bac078e48029a051f63e4ac5d4d37424219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24b81668dacaa26247cd267ae745d09f1c70db8eccbcb107a26d2566f819ec9f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    args = %W[
      --infodir=#{info}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --disable-bump
      --disable-earlydata
      --disable-examples
      --disable-fortress
      --disable-md5
      --disable-silent-rules
      --disable-sniffer
      --disable-webserver
      --enable-all
      --enable-reproducible-build
    ]

    # Extra flag is stated as a needed for the Mac platform.
    # https:www.wolfssl.comdocswolfssl-manualch2
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags "-mdynamic-no-pic" if OS.mac?

    system ".autogen.sh"
    system ".configure", *args, *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end