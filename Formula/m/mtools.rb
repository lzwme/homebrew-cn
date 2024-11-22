class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.46.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.46.tar.gz"
  sha256 "4243e79af24133525755f37fc85e9c09fd904c89561ee19cd669454fc5b28ded"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06b18781ccf00aed5ebf26e14addc0b0c7da5b6a383b810e7712f850929e0b9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a91d7b683a0d78cafcf56dd581908cbca2e62673922d0e5de3ebf4cd9b271118"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d9f7d214585bb4ea9cbd7b47e010032ec33d59838b3c08932b58305d00fe7ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea49ff9deab0af2151880a8e9f47fa31541da1b696c31609e73b35af919f0dd2"
    sha256 cellar: :any_skip_relocation, ventura:       "bc35bae1aea11e78e87ec2d747a4cef399e66418d548878de635d5a968463d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c32a679fe8d4a8e8d9ba5c92385dc7047263517df73d8ab28babc4e413cb2aa"
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]
    args << "LIBS=-liconv" if OS.mac?

    # The mtools configure script incorrectly detects stat64. This forces it off
    # to fix build errors on Apple Silicon. See stat(6) and pv.rb.
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtools --version")
  end
end