class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.5.1.tar.gz"
  sha256 "6d60c2eb9e15f6a23743ce7fc3687a8880042d7fca43572e73ca76ed003de258"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "35a4aefb1aaddaed3f8f55d19f64305389ce0baa468e6a7ce8dfaac449434290"
    sha256 arm64_ventura:  "beb7db22123b9d7d43fa806813cf1252509e88c00e30f53ee7cc8345b6b3abd1"
    sha256 arm64_monterey: "6b41ec90f306f21457954670e8a551d4fd67bdbd53079533d68f844f734abec9"
    sha256 sonoma:         "c175eb4e157661dd2d236ad51f4a490bf52d45856df7371b45e2a439ffe0e232"
    sha256 ventura:        "c2fbc2e040bbb19ae4ecd3cce1e7eadb0b9894678ddfe75c624a898fcf5efb86"
    sha256 monterey:       "7dd9026a6c7a7fb2106c3b79508c6ead6b65787b4084cbb12ef75d897360a040"
    sha256 x86_64_linux:   "cd5af9e632b035b4a82e2f297938fffea0922a08d8c7be5113199d3936867ad9"
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
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v", 1)
  end
end