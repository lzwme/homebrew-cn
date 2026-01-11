class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/650/aqbanking-6.9.0.tar.gz"
  sha256 "1aad2ab582d60ddf0c253245bc1c2750fff1bd6a35aca43ad2bc0d225d32a8f6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "2e186cd110a8e9f080460214071b4eaa69fe66da9339961d758a5e8b89b25cdf"
    sha256 arm64_sequoia: "5c3c32180215f2cbd46fb676d9941a128acc8dcabe999f06f5df33bd20452325"
    sha256 arm64_sonoma:  "8f7e8d527349355729ce844c677bea0b07535eee244565e169d0e8926b674520"
    sha256 sonoma:        "672d99431bf05be79d6eb6565354584cae8ba007bb9435fcb980531accabd9f6"
    sha256 arm64_linux:   "e6660ae83cabffce25cd105ad238a336700606c2de8b52a75089606aebe09bee"
    sha256 x86_64_linux:  "8368797630c53452fb764274c232f0942136c390be376cb33eede69d596348fc"
  end

  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt" # Our libxslt links with libgcrypt
  depends_on "openssl@3"
  depends_on "pkgconf" # aqbanking-config needs pkg-config for execution

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.deparallelize

    inreplace "aqbanking-config.in.in", "@PKG_CONFIG@", "pkg-config"
    system "./configure", "--enable-cli", *std_configure_args
    # This is banking software, so let's run the test suite.
    system "make", "check"
    system "make", "install"
  end

  test do
    ENV["TZ"] = "UTC"
    context = "balance.ctx"
    (testpath/context).write <<~EOS
      accountInfoList {
        accountInfo {
          char bankCode="110000000"
          char accountNumber="000123456789"
          char iban="US44110000000000123456789"
          char bic="BYLADEM1001"
          char currency="USD"

          balanceList {
            balance {
              char date="20221212"
              char value="-11096%2F100%3AUSD"
              char type="booked"
            } #balance
          } #balanceList
        } #accountInfo
      } #accountInfoList
    EOS

    match = "110000000 000123456789 12.12.2022 -110.96 US44110000000000123456789 BYLADEM1001"
    out = shell_output("#{bin}/aqbanking-cli -D .aqbanking listbal " \
                       "-T '$(bankcode) $(accountnumber) $(dateAsString) " \
                       "$(valueAsString) $(iban) $(bic)' < #{context}")
    assert_match match, out.gsub(/\s+/, " ")
  end
end