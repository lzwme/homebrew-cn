class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/634/aqbanking-6.8.2.tar.gz"
  sha256 "10b14c92d76ff13652e00b5c496001601f0d9465c5acb1b1b682d451022406ec"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "105e245881c755ad3ef896386a4dd5848e885aa71d814df4b147357636911449"
    sha256 arm64_sequoia: "73b04298da2aa314f4af06362dd9178c651cdae20d28ab9a57c66c75507c5ff0"
    sha256 arm64_sonoma:  "977857fbf46e5a53deae8c5b0f2ed348aeabd96c85e2725fcc8a1db0479b2a32"
    sha256 sonoma:        "15935add475443421f337d3537d47c703e08511225e45becab23a544425d9831"
    sha256 arm64_linux:   "9d7a8785eb0bd17d44c64a62613bec6e629a6bfc1df753db5542c54487bd5d9a"
    sha256 x86_64_linux:  "ad51bb9ffe448056610987e47d07d09edc9d3119d043639d5599327315574b24"
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