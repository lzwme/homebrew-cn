class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.4.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.4.tar.gz"
  sha256 "09c1ce74a25fc3b48c81ff146cbd0dd538cbbb8fe4e2964fc2fb2b192f6a1d2b"
  # Complete list of licenses:
  # https://gitweb.torproject.org/tor.git/plain/LICENSE
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
    "NCSA",
  ]

  livecheck do
    url "https://dist.torproject.org/"
    regex(/href=.*?tor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8e16160b00e6869a069e9b5aef9e6153ce682801d225eeca1cba7cb6daf679f0"
    sha256 arm64_monterey: "dcf0b01f3ba258e3716fc632671c688ae064016354872be181645c36dbb52de1"
    sha256 arm64_big_sur:  "f602190ebfc43a551ff3dd2d0e29866bf4cb7dfd66427ba9d069f9ca98340944"
    sha256 ventura:        "d1bc85e6d5d0581c3e05fd415e8484c32ebfdb66c3650a7a139041fc01ffc39d"
    sha256 monterey:       "9051edd72d2087cec17fcc33aed6dbdfe0dc2792cf01d3d0470c01808ca4b07c"
    sha256 big_sur:        "df6243609e421bd3a0bb9f9a58ad0984b6dc871f1403106d4e50fef9b8d64de4"
    sha256 x86_64_linux:   "37a5117b6931dc404d6c05691108bd5febac5f0406a44df64bbcec699d064073"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_bin/"tor"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/tor.log"
    error_log_path var/"log/tor.log"
  end

  test do
    if OS.mac?
      pipe_output("script -q /dev/null #{bin}/tor-gencert --create-identity-key", "passwd\npasswd\n")
    else
      pipe_output("script -q /dev/null -e -c \"#{bin}/tor-gencert --create-identity-key\"", "passwd\npasswd\n")
    end
    assert_predicate testpath/"authority_certificate", :exist?
    assert_predicate testpath/"authority_signing_key", :exist?
    assert_predicate testpath/"authority_identity_key", :exist?
  end
end