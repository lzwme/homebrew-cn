class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-7.0.0.tar.gz"
  sha256 "7bcd1313118366451465dc3f8385a3f6aadd084ffe44dd257dda8105863bb769"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "cee8bd640646582c9c1a5ede55986e58846fcdadfae410e1ccbdf4486550121f"
    sha256 arm64_monterey: "9feebfaafd683ac97337c49f4bbf8b199458615796f1b07ca81819368fef1904"
    sha256 arm64_big_sur:  "1fa74b6a60717ba11214bdfceafca461c2c8b2a9f3fd4dac2d8c94df5f6ad6cd"
    sha256 ventura:        "fe98fc423833295e401dacfc1f227c1c309b60eda34855f1e504172f1cc3942e"
    sha256 monterey:       "b225af0c99ba8da5681bcb07c32d484094def58fd22cadb375a13943ab5d1e8f"
    sha256 big_sur:        "e4fb78007e80ee31f3353d801f102f4c74ccfae38bb3856f3f313273910f9d9f"
    sha256 x86_64_linux:   "4b462af9ba4cd5cb9bf97d4d47de0501fe8cddcd85920253e4d97d3c949ff421"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "lz4"
  depends_on "nspr"
  depends_on "nss"
  depends_on "pcre2"
  depends_on "python@3.11"
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

    inreplace "configure", "for ac_prog in python3 ", "for ac_prog in python3.11 "
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