class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/643/aqbanking-6.8.3.tar.gz"
  sha256 "8281b5620dda71b3d13bfa2d0cf3258c45b5c23e00a507e77baa7acbb3a3318b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "43dadaf8d57277f799cf75a3553977628425942a9e91f3e7839788af9ac8d09f"
    sha256 arm64_sequoia: "79b4e6be8858770a493e53726069c6ac21c5999556fca77e79ce9603d69aedfe"
    sha256 arm64_sonoma:  "0897f2b694400e6129cc98788055c53530b50e1269b2e6a4d7403cdd5f5b0f81"
    sha256 sonoma:        "842ce1fbc4a58b20ecf05f52c3d5a3be47e0603c8ff77d149ccde1b55f275b2d"
    sha256 arm64_linux:   "fc4db45afac4d5c44172b779fab1c22ed019310aa6215225d99ef8802ebe4c4e"
    sha256 x86_64_linux:  "d530d8070d298e064cb9a49b96509b919e7564c6a0436a107114139aad0e48b5"
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