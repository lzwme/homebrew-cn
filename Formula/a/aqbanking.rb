class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/648/aqbanking-6.8.5.tar.gz"
  sha256 "7277edb4240f866534cdf49a54dad104b5c4e3e6eeaf78c550e86c53954754ce"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "e9d3d835760f735273938d802cb6051f2d228110c83c80cf2c435f3234787596"
    sha256 arm64_sequoia: "f60eeb0a97c05c9fddd311627f51e2ffcead36f7bb7979659d4cd395923d88ab"
    sha256 arm64_sonoma:  "0aefa700611a0924a78ad3f6fe8813e54d492022ce4a4f1be7bb36a2111a33a4"
    sha256 sonoma:        "6269a0f599df1888ce454e65c547117a4551aae53d8fd84035767a26214bda12"
    sha256 arm64_linux:   "691215f39516f3e8a401dbb9827cd8ece9f7c69d4719c3224fa8c83dddff8b47"
    sha256 x86_64_linux:  "703cca8ef9dae9d919b5d1b75fbfc83a5a7b492c8df679e746945126037c4e72"
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