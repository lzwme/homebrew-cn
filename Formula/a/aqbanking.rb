class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/646/aqbanking-6.8.4.tar.gz"
  sha256 "53e297a202312dffae1091eaaa86e46a699febe0947857606bc2535adfdbf191"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "964485a93ceff6f560d5923d9debb72d72725e61ebd2f53f904861505ce2e6c9"
    sha256 arm64_sequoia: "ea888b22c1e16cf1707e3c5fe4f185a972fdd2c65bb7a87ba3720383ed9dab0d"
    sha256 arm64_sonoma:  "91b21fdb44a245f59f62b882f0d672704934cc727ab42234c1ba1e7f0202019d"
    sha256 sonoma:        "92f3fd5e1f483e0680d4120ceb0da1ef4f1d95657ce556a7dc057a23bcde98d8"
    sha256 arm64_linux:   "4f22322570b07a7d45acdeb93b0ea538276a13a0684c593a95a9633d5afda52a"
    sha256 x86_64_linux:  "09cc71a357a6290cdb6f93a7f945ab0101c84f4bbf0bc3361d3108738bb1a438"
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