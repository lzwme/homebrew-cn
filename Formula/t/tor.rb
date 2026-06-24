class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.9.10.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.9.10.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.10.tar.gz"
  sha256 "dfee904eae8fc38a2e3b351154f8ac0fca2a6649038f1a7e6a59461de57da47f"
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
    sha256 arm64_tahoe:   "37ad44db94d7d9ee0e316f970367ae2522f09835223e9e2be4a6fb0cac8aff7b"
    sha256 arm64_sequoia: "33948b63557575bfe3260b0dcccf1b0479d16647b4dfb1d7390f61ff47c8a174"
    sha256 arm64_sonoma:  "c25a14ac123fd5fb2ba0a0276feeacb6755bfc90f0cd48ae99f49fac54be9ca5"
    sha256 sonoma:        "8fc8b433a17c627ef72c95e1d318b0f3c7a05e9d0f0b558676f0880e63e55f7b"
    sha256 arm64_linux:   "af0ae93dedb88d3474968b21981361e399226d2393e675e768d9a87c2fe4d323"
    sha256 x86_64_linux:  "c57dd6d39636742059f9f97ec20684a3aaf01a1f8b8dfbef69b3bdbce3325c9c"
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
      --with-openssl-dir=#{formula_opt_prefix("openssl@3")}
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