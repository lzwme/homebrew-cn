class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-7.0.2.tar.gz"
  sha256 "b4eb604838ef99a8396bc8b7bb54cad11f2442cbd7cbb300e7f5aab19097bc4d"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e15bfd1b58eedaa4fc944947b1602796f9203affc2ef1535a80266c9e6f9a243"
    sha256 arm64_ventura:  "e45883309a6be49ab0229b42f68a8c801f9b594d09ce449ff35990ee321f654e"
    sha256 arm64_monterey: "9ffc4ba4da4b02f90618352b917d80b8f8de105a5b2a426f85f4831dc7232f10"
    sha256 sonoma:         "e8611e95ed8675534e74a3247fec210705219b215fb4182a3b5bc6d081d63165"
    sha256 ventura:        "846c9440c73d6d6cff7648fe58fe75f188248ada7ec79dcf58dba778b3f55ba6"
    sha256 monterey:       "86c83f58625ff651de5808db5c95bb8f0e8df62011fd4b365e4b4166d3ead4e6"
    sha256 x86_64_linux:   "7c0612bc088d482ce6468066cd93de8929494d759c8c6447d56a2d7abcf60328"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "pyyaml"

  uses_from_macos "libpcap"

  def install
    jansson = Formula["jansson"]
    libmagic = Formula["libmagic"]
    libnet = Formula["libnet"]

    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-libjansson-includes=#{jansson.opt_include}
      --with-libjansson-libraries=#{jansson.opt_lib}
      --with-libmagic-includes=#{libmagic.opt_include}
      --with-libmagic-libraries=#{libmagic.opt_lib}
      --with-libnet-includes=#{libnet.opt_include}
      --with-libnet-libraries=#{libnet.opt_lib}
    ]

    if OS.mac?
      args << "--enable-ipfw"
      # Workaround for dyld[98347]: symbol not found in flat namespace '_iconv'
      ENV.append "LIBS", "-liconv" if MacOS.version >= :monterey
    else
      args << "--with-libpcap-includes=#{Formula["libpcap"].opt_include}"
      args << "--with-libpcap-libraries=#{Formula["libpcap"].opt_lib}"
    end

    inreplace "configure", "for ac_prog in python3 ", "for ac_prog in python3.12 "
    system "./configure", *std_configure_args, *args
    system "make", "install-full"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: lib/"suricata/python")

    # Leave the magic-file: prefix in otherwise it overrides a commented out line rather than intended line.
    inreplace etc/"suricata/suricata.yaml", %r{magic-file: /.+/magic}, "magic-file: #{libmagic.opt_share}/misc/magic"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/suricata --build-info")
    assert_match "Found Suricata", shell_output("#{bin}/suricata-update list-sources")
  end
end