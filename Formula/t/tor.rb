class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.19.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.19.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.19.tar.gz"
  sha256 "3cb649a1d33ba6a65f109d224534e93aaf0a6de84a5b1cb4b054bfa06bb74f5a"
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
    sha256 arm64_tahoe:   "112ffb60658314ce8f8477bd9bd261b9e92b2fa009ef6a25b932d8f7c735bb04"
    sha256 arm64_sequoia: "ef4680d2a89bfcd79619759980697bac195bfd77a3a05f99ce44c91087b4f3e9"
    sha256 arm64_sonoma:  "bace408b993f6210dd85a1d51de2116c9e3a573b4cea59db3bd0e59f532e2c6a"
    sha256 sonoma:        "48a14ff9cd27a54313b97c900920878f9d4c90f7fc1a2069b6a1c216ea4e9726"
    sha256 arm64_linux:   "b525a9d1593e101b0dab070c6c65549004705b422f5efc02293f8f3d087bcd56"
    sha256 x86_64_linux:  "2f01104d624c0f360564a0f7b5783aea9563ea546f48ceeb822cbf9c340ef5f6"
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