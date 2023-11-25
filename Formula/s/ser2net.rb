class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.0.tar.gz"
  sha256 "58a7ba97761f96b9228bccf6367c2715c0c0be1f99e0a114d429d8c1fcb9c8b2"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "090b9e0c67c15701fd5ae0a90814170b14c0ec3fc39376d3e2eca0cc476bb10b"
    sha256 arm64_ventura:  "750330c67483328590cc20df550575830452d7992ee53be9b000420346d250c2"
    sha256 arm64_monterey: "42fc3e0bfbd57b95883b83a342bb8ba1d822e69ff56178817b07db04c14345c3"
    sha256 sonoma:         "ee2949ef2a3a834f07e478973d808538bb036e7d9fc4885852887b88ab645ab4"
    sha256 ventura:        "c1bd8f6d94c70319ef0da9c270ee1aea140f8c61341c86dae72026a6e0463efb"
    sha256 monterey:       "45bfb3bce5ad1066e191a4f6b61ff33195a636cac501a473930ba09921454b69"
    sha256 x86_64_linux:   "b8a7b85282f015002a5e58e3b2ef2168289b77e7361e42669707bf12b631b245"
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