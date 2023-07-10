class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.13.tar.gz"
  sha256 "ed8b98448d535111d9a593b067601a8b53e2874814d706b2421a9490a660d265"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c961d27f7151bae65d09c73407af4fdaf4302bcb257c047dbda20666747b5658"
    sha256 cellar: :any,                 arm64_monterey: "6960098e88ae28d254d41eeac9c64f00e5f8a8c4b9d3a4711cd9200afe3d7e42"
    sha256 cellar: :any,                 arm64_big_sur:  "c7550df020599602d563c752cf919fc35be33bd2c993ef5928d319245422049f"
    sha256 cellar: :any,                 ventura:        "707fb1164096869754cacf44ca18d8bfaee5db811fc734b9d1575f3b9f77abdb"
    sha256 cellar: :any,                 monterey:       "b18a951df402a609ee0236f5ffc325d255f901fc32dc1da3dd8e273874ac322e"
    sha256 cellar: :any,                 big_sur:        "dbfffdc465941f83e919f704bec1d0f906e789651f645486d23b02554d30d45b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375f883af856d85b9bd43799628b8b663a26ed9ca2657d1c403c604c9b44a5ae"
  end

  depends_on "libyaml"

  # pin to use gensio 2.4.1 due to arm build issue with 2.6.7
  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.4.1.tar.gz"
    sha256 "949438b558bdca142555ec482db6092eca87447d23a4fb60c1836e9e16b23ead"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  def install
    resource("gensio").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/gensio",
                            "--with-python=no",
                            "--with-tcl=no"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/gensio/lib/pkgconfig"
    ENV.append_path "CFLAGS", "-I#{libexec}/gensio/include"
    ENV.append_path "LDFLAGS", "-L#{libexec}/gensio/lib"

    if OS.mac?
      # Patch to fix compilation error
      # https://sourceforge.net/p/ser2net/discussion/90083/thread/f3ae30894e/
      # Remove with next release
      inreplace "addsysattrs.c", "#else", "#else\n#include <gensio/gensio.h>"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  service do
    run [opt_sbin/"ser2net", "-p", "12345"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end