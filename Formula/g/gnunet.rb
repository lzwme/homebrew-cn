class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.22.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.22.0.tar.gz"
  sha256 "fd39730b904b9933f78d3b4b8e81da3239d4796ca105e4644739c67e4be071d9"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e60d8636826acde9f320cb0212c6da18007766b52d9b98dfeb924fd1fd83af2"
    sha256 cellar: :any,                 arm64_ventura:  "73466ecf7e8e712da3d2674ccfc3ea6dc3dcefeec0066cdb0fb3dc97da8954da"
    sha256 cellar: :any,                 arm64_monterey: "e51463b2a06a6d1e2b1b8c7c916886f6c3edb419facfe82a8580c1d23cf54524"
    sha256 cellar: :any,                 sonoma:         "9b02c6eedb4a5426eb02b11860c07c479ef8dabb1ba4e99e71d89ced7bf41ac4"
    sha256 cellar: :any,                 ventura:        "fcfb6f4880cf37d7d010af900c19c8fbea5ac29fb0a516ee120037651399db41"
    sha256 cellar: :any,                 monterey:       "1791816def9991d6f99736aca39b1ee0adfc9737e7565a664d36c36af2aff787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73a209bb6456389d530979b995a1fb64479ed50881523719369cd0fc6fafb356"
  end

  depends_on "pkg-config" => :build
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
    ENV.deparallelize if OS.linux?

    system "./configure", "--disable-documentation", *std_configure_args
    system "make", "install"
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