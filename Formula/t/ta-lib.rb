class TaLib < Formula
  desc "Tools for market analysis"
  homepage "https:ta-lib.org"
  url "https:github.comta-libta-libreleasesdownloadv0.6.3ta-lib-0.6.3-src.tar.gz"
  sha256 "a59ec9c6c21317c75fc93ad9a0710f50d7353018460d0958a233c32733139dbd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21b63d6d22fd47d5aa970d23081091d3facccdf2de629df7dc622d56578a8ef4"
    sha256 cellar: :any,                 arm64_sonoma:  "b4fff9953f7e5341f3e5a9aeb21a61945c2b9e145d53b5148632b1046ced1952"
    sha256 cellar: :any,                 arm64_ventura: "1c7986786ddd9bbdfafa1b9353a6a9049fba651deb3f1b98e2fcf7d3d1f100f9"
    sha256 cellar: :any,                 sonoma:        "9939462854b08f3e99a8bb8e09e53b509bd1aef20fb17233ee21bf77c88cdf53"
    sha256 cellar: :any,                 ventura:       "d4269abb35e1a7ef74c325e50812c3144c059dfdc0c4c8ccc91f90287b7a9519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82ce376e0540be0dce4ce37bc5c7a68ae33797f92b06f71d5199749802bc80c3"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.deparallelize
    # Call autoreconf on macOS to fix -flat_namespace usage
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system ".configure", *std_configure_args
    system "make", "install"
    bin.install "srctoolsta_regtest.libsta_regtest"
  end

  test do
    system bin"ta_regtest"
  end
end