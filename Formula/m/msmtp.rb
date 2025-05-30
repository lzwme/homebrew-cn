class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.29.tar.xz"
  sha256 "13a78f3c6034b33008a7f2474fdddd0deaf7db6da89d0791d3d75eae721220d7"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "5793f70b0e512d28643bda350e34e14e4679b9299385a9b4301787f3a27aa6bb"
    sha256 cellar: :any, arm64_sonoma:  "70bbf8f1ba7aaaf77c7df3ea3deed9fadf430f36c9756c0076c33a1bb805a406"
    sha256 cellar: :any, arm64_ventura: "ac497ad24c148063033e861fa66542baed40e387659852b2fe21842ebd9385ff"
    sha256 cellar: :any, sonoma:        "e789a1a773f3de817d23924030e299344a53f8eb2383fc2bc301df0709e70e21"
    sha256 cellar: :any, ventura:       "74990ba3528f5f6053e428e51c4f36f2dfb35b9dd3ddcfc41c08fe2666ab25bd"
    sha256               arm64_linux:   "0b92a6ebef5af39e7b5abff48ddc91b58fec162c9acd58e37f8fc8d14e2888d9"
    sha256               x86_64_linux:  "2be130885b631ec5d17701fd8ad9f5a4a98834ee219bc04e0c9b172328f00a30"
  end

  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", "--disable-silent-rules", "--with-macosx-keyring", *std_configure_args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end