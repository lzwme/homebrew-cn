class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https:github.comOpenSCOpenSCwiki"
  url "https:github.comOpenSCOpenSCreleasesdownload0.26.0opensc-0.26.0.tar.gz"
  sha256 "837baead45e1505260d868871056150ede6e73d35460a470f2595a9e5e75f82b"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "caa9eec5975467f057796c2e06d68e9d0b1729ab0fa8030ac813e851274d884e"
    sha256 arm64_sonoma:  "22c6c89a91bf51ec3cf6c331ac3f8d14ddc0f581f57159f6a4ade52b70183ec5"
    sha256 arm64_ventura: "0869255f1694e73bcf34a29bf91b02ce29efaf86fc568ade7f47c2e0b3abcad9"
    sha256 sonoma:        "2e6b747128a0dc00b95c12c5b5f7dadcd56082aa3e011c4b7aee3af64b0d23cd"
    sha256 ventura:       "26355b938b0c266c8da17b69dffc62e6202a1b6eb58a24cc6ddff43a482801c9"
    sha256 x86_64_linux:  "af4c785dfbbea6582d375460585ea55ee030a627b6efd945e10d6d792a180808"
  end

  head do
    url "https:github.comOpenSCOpenSC.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "pcsc-lite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "glib"
    depends_on "readline"
  end

  def install
    args = %W[
      --disable-silent-rules
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}docbook-xsl
    ]

    system ".bootstrap" if build.head?
    system ".configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    on_high_sierra :or_newer do
      <<~EOS
        The OpenSSH PKCS11 smartcard integration will not work from High Sierra
        onwards. If you need this functionality, unlink this formula, then install
        the OpenSC cask.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}opensc-tool -i")
  end
end