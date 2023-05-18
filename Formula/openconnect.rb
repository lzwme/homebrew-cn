class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "https://www.infradead.org/openconnect/download/openconnect-9.11.tar.gz"
  sha256 "a3c63441395ebc073995a5f4713ab5599af63c04f7492b9b48df11a7fbcb06c7"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.infradead.org/openconnect/download.html"
    regex(/href=.*?openconnect[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4c6cbc54440c7c62a7816ab6a2751de284aedf3f7e0fdc5c5e2bb257eb5d30d6"
    sha256 arm64_monterey: "632379312ace173ee8df4ab6a34b8790cda132fbb04c5e8699f66a750bb40338"
    sha256 arm64_big_sur:  "116f5cf88b9018e4b5de451de7867a0472a3789792366527d145b4e333c8f86f"
    sha256 ventura:        "b2df25b2d3fe41f6f692f11bd600f0612c8d416a0824871a74bce9eb44776017"
    sha256 monterey:       "12bcdba25dcefcd693c93aaa5fc570fe9599e02cce5ccfdbff2d4f3cbc4c1dff"
    sha256 big_sur:        "2d9860fd935442d985c608c044b00318bd5c43ed1e7226e3b4112c0a925c18f7"
    sha256 x86_64_linux:   "e2d6425aa942d399b1cec3e39d4d35a447ecf4cbe46a2e22243fc305659f9d23"
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "stoken"

  resource "vpnc-script" do
    url "https://gitlab.com/openconnect/vpnc-scripts/-/raw/473d3e810b8fe8223058ab580fac20c53204e677/vpnc-script"
    sha256 "4e0d4367806c8b54da76aaae4bb550993d8155894006705d21b16eabdbf47559"
  end

  def install
    (etc/"vpnc").install resource("vpnc-script")
    chmod 0755, etc/"vpnc/vpnc-script"

    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-vpnc-script=#{etc}/vpnc/vpnc-script
    ]

    system "./configure", *args

    # We pass noinst_PROGRAMS to avoid a failure with os-tcp-mtu, which is optional
    # Issue ref: https://gitlab.com/openconnect/openconnect/-/issues/612#note_1394913896
    system "make", "install", "noinst_PROGRAMS="
  end

  def caveats
    s = <<~EOS
      A `vpnc-script` has been installed at #{etc}/vpnc/vpnc-script.
    EOS

    s += if (etc/"vpnc/vpnc-script.default").exist?
      <<~EOS

        To avoid destroying any local changes you have made, a newer version of this script has
        been installed as `vpnc-script.default`.
      EOS
    end.to_s

    s
  end

  test do
    # We need to pipe an empty string to `openconnect` for this test to work.
    assert_match "POST https://localhost/", pipe_output("#{bin}/openconnect localhost 2>&1", "")
  end
end