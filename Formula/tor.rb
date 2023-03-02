class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.7.13.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.7.13.tar.gz"
  sha256 "2079172cce034556f110048e26083ce9bea751f3154b0ad2809751815b11ea9d"
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
    sha256 arm64_ventura:  "ab4cdc345c9f80dfa3e1fd1eeedc7b8d7e15550aa96449e00e8f060fd4f7fad8"
    sha256 arm64_monterey: "768aa6a027bef375524d863baca66fbcc2e8d012c98d476a08c9ffc60c0c0364"
    sha256 arm64_big_sur:  "55f8d1cf395876caa55ab9c134eb49aeca91f4056b52d9d6a7b58a4d597d2e3e"
    sha256 ventura:        "bde133cf943c4079b84e6b88e8d7caaf36e39fc3aee3a613d98371cfb8bf7e41"
    sha256 monterey:       "c7cc7a407df901e035b62ec1d5e254cc3a0f7a407d6de07b77b96bf2ba38cf16"
    sha256 big_sur:        "f1450f57dd077481af59d3f8dcbb1f68438cfee0efba367d67505abf49239b38"
    sha256 x86_64_linux:   "4689141fbbbf9e1d50c81e7d34ecdd684b8ed67fd1e09ca9caaa908afb17e43c"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@1.1"].opt_prefix}
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