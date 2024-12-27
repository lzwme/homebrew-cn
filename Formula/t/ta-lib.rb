class TaLib < Formula
  desc "Tools for market analysis"
  homepage "https:ta-lib.org"
  url "https:github.comta-libta-libreleasesdownloadv0.6.2ta-lib-0.6.2-src.tar.gz"
  sha256 "598164dd030546eac7385af9b311a4115bb47901971c74746cbef4d3287c81e0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49d87c2962204bd32cfcb57e78a2c215ab57efbcfb8be4caca17d032a7d4c151"
    sha256 cellar: :any,                 arm64_sonoma:  "8fd696175b4e80ad8c3f2d899bc2949886bb45cbe51f1a2d7d2d7d8215ddfcee"
    sha256 cellar: :any,                 arm64_ventura: "558130e9bf0054922bae500855275d9d54dd4d921a31b2daefb5aed0590c905c"
    sha256 cellar: :any,                 sonoma:        "d56d36597eb16861dcbfeef84a08a0729f2674ea7ac7144f78a514e62f0f6c6d"
    sha256 cellar: :any,                 ventura:       "6f926617fb71bb56f7dbd3fce614e08aef48e51be3b72d66344cb8ea2bb6bc2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff915c3a89a1e10122c5adc45b0e76448b36f1b53d4b1d802ed5b44de2b1d1b"
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