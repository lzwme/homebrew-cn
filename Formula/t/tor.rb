class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.8.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.8.tar.gz"
  sha256 "21bbe908cafeabff04636d26293540aa9366eb1cf389bc65dc2476c93e688004"
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
    sha256 arm64_ventura:  "1c5c91bc72d3e2ce8760a0eb44509871ed7581e02dd6dd2b8a0a1788befbdd6e"
    sha256 arm64_monterey: "f9a2ea0f396a09a6c3711fec1125ffabe962c38e04b30065f63d1a2b28330a5d"
    sha256 ventura:        "e1bcf6887b2efaa698a663c29f4f7eaf367eb2cc6dbea1fb95bb1019cdf75da9"
    sha256 monterey:       "af439d1ef2783a20c5cbe912ade8e1702343fd1f509c98aea0f3aebff73396cf"
    sha256 x86_64_linux:   "c97f4fb952cb89f9c87af95836b0d1f21a3c647fddbef9d2efdaf992041297dc"
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