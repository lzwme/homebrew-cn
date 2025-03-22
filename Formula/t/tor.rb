class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.15.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.15.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.15.tar.gz"
  sha256 "5d5d99e21992c4c71af1afcef16c70f4c5e7ee021633ac138b2a2761be75064b"
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
    sha256 arm64_sequoia: "7f93ba499b0e8b4b1d7b68ba8e6888f4bcd762fbe86391ccadd48ebb6a8b2f59"
    sha256 arm64_sonoma:  "e1c6eed0b9c562d41170a2f46936a7a6fa790bf8b4cbca809850fe5aeddf1455"
    sha256 arm64_ventura: "c678018b39a93e36f7b8784f7c35c90ee0b6830a16b5dbab130ae17293989a85"
    sha256 sonoma:        "7cc71b145d8d6772f54a011d5df72a47a2ce599668aa964d1a17998762f85e22"
    sha256 ventura:       "c79357a19f3032927d095d360eb179e0e73e97143d00deedb3abeaa0b9e4f456"
    sha256 arm64_linux:   "2c8c9d97b80ab731926ef263b56321f2e638026ceb9ff17ec68afdba7ccf94a5"
    sha256 x86_64_linux:  "505f6e83ce334976eb557bb7f6050b98ddfaa99927b2e281e15ce89a5954c52f"
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