class TaLib < Formula
  desc "Tools for market analysis"
  homepage "https:ta-lib.org"
  url "https:github.comta-libta-libreleasesdownloadv0.6.1ta-lib-0.6.1-src.tar.gz"
  sha256 "887372f41b6de9cb2a957d25ea5f87453d419aa388f208c7bf57f6019d6e3c2d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f6e1cdd6318b2cd86760e12de7ef950cafe4816e7c6b0e51f185ce62e167ecf"
    sha256 cellar: :any,                 arm64_sonoma:  "fb1d96d105ee245e1b1ceacc45dcf321f7b6cc06f0b10fddee3d93ac3274b480"
    sha256 cellar: :any,                 arm64_ventura: "b4fc78dcf2c6fff81ff3a3375cf2f82924c17d987bf8192505375e9094fbec70"
    sha256 cellar: :any,                 sonoma:        "83d3a19fd07580171ef7ece8d5d03050e5e90bd9379302dc58451923289113da"
    sha256 cellar: :any,                 ventura:       "8f9546efa54f086eb038d03cb7c8a4cea24e9bd480a6bc9269cbfe09d6f94539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6622688adf7bfbdd9ecb473950897f77d659db6f82f3ecf851881c125c9dc1ba"
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