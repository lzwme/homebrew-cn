class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.20.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.20.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.20.tar.gz"
  sha256 "1bb22328cdd1ee948647bfced571efa78c12fc5064187b41d5254085b5282fa7"
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
    sha256 arm64_tahoe:   "38bcf3c6a6f51d07e405ac2e23a9e3b639f72b1045d30b34cd8e3e82f5fa0399"
    sha256 arm64_sequoia: "df7053c0aa7c00fdf51c06e827c2581f2fc2616caa36f1c0e55d3d860798be49"
    sha256 arm64_sonoma:  "492a49f07d4a05199c681f9ec5afdc4d92823928e581d2e44a4af743efe12498"
    sha256 sonoma:        "7a111d58e47f1521ac9a076c7df3c5cea7cf73b797de371d0d827393208d63d5"
    sha256 arm64_linux:   "5f58e1f32d2b35b92dad3ed6c31d9318c62081c3fe8b102e7c2aa070ccde6654"
    sha256 x86_64_linux:  "b76bd596e0a7f6d700701f56094e293d185485f577bb7b3e3972465ce2b1bcf5"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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