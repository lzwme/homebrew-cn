class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.4.9.13.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.13.tar.gz"
  sha256 "5e748d3272cdf44a7d7741173f371c8def3d96eecb77e93c89c50663ce9cc792"
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
    sha256 arm64_golden_gate: "59e1d50a3c68c2822ddf6e47b5b3d9a3e156d99090fbeaf8899bfca5d0220dfa"
    sha256 arm64_tahoe:       "806af5d40a60fff749cb8eb1866ff26bfcea6f0f2c99b06fd02c5412f5574844"
    sha256 arm64_sequoia:     "25ff80bb2dcedd0fb40d1e0999eb6cb9bfc5f2e45a9155c4b6f29ab8910f6320"
    sha256 arm64_linux:       "8e9696fd72331bebdcfd957509314e60e7afb19410f6996224e9743aa974c79c"
    sha256 x86_64_linux:      "7a37c732eb7718bb7983db9f1aea1b9715f7007a286b468adaaf3d03272f10db"
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