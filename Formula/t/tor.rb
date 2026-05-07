class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.9.7.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.9.7.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.7.tar.gz"
  sha256 "5a740f32f688ac89c066345c38b47ba286b0c4394d351b251ff48b6a5394618f"
  # Complete list of licenses:
  # https://gitweb.torproject.org/tor.git/plain/LICENSE
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
    "NCSA",
  ]
  compatibility_version 1

  livecheck do
    url "https://dist.torproject.org/"
    regex(/href=.*?tor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "dea0f954387a76d9f32d9f5294fa12299b298de452ffb9a8db7520f8cfdab270"
    sha256 arm64_sequoia: "c7dc7a54234b0e96125ad27c570b3fef30b267affd6a3612cfe29c1149f00e5a"
    sha256 arm64_sonoma:  "e7bb5a645ebf002df9466094fcd933837111e40a051dab69c107d2943081f910"
    sha256 sonoma:        "e5ed7607470d2e6930432929c799a48ba9d9b1f94560ecd1a2ec3c2ca9f7c1d4"
    sha256 arm64_linux:   "1837f7474e02a4c6d45764f55e841a10f205094cadca835cd0e698b2c458c240"
    sha256 x86_64_linux:  "bdfad8930937a97e6d88a33b0a7773c78b8ece87b5c84d4aaa363e2a3a61a8f3"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
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
    pipe_output("#{bin}/tor-gencert --create-identity-key --passphrase-fd 0")
    assert_path_exists testpath/"authority_certificate"
    assert_path_exists testpath/"authority_identity_key"
    assert_path_exists testpath/"authority_signing_key"
  end
end