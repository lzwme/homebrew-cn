class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.24.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.24.0.tar.gz"
  sha256 "06852f9f4833e6cb06beeddf8727ab94c43853af723a76387ad771612e163c57"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f150065b94790302b7e758053539ffa71e1d745296b89b75569676a469b471b7"
    sha256 cellar: :any, arm64_sonoma:  "7ad36093d11df8d8e7bb993d4d53bb7be408b02077cef8b9622f8df6580fb352"
    sha256 cellar: :any, arm64_ventura: "9828a2b6b09942caedb625bec1412d91bba4cb05e6306a2766fab88684163323"
    sha256 cellar: :any, sonoma:        "3c213406363c2c285913937096d2b12402cc35814e8a3fdbf95114f1b0468d07"
    sha256 cellar: :any, ventura:       "b3a02e5ea306d9e16fe9a66f4ba93ff5a67d4252115dc0901b9d0c2c7f534adf"
    sha256               x86_64_linux:  "037fc98ad37b78f34dc88e39dd5ab9cd9ceed9a64446ea8d0968e0702ee120ed"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libtool"
  depends_on "libunistring"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"gnunet.conf").write <<~EOS
      [arm]
      START_DAEMON = YES
      START_SERVICES = "dns,hostlist,ats"
    EOS

    system bin/"gnunet-arm", "-c", "gnunet.conf", "-s"
  end
end