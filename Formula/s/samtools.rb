class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https:www.htslib.org"
  url "https:github.comsamtoolssamtoolsreleasesdownload1.19.1samtools-1.19.1.tar.bz2"
  sha256 "1f94915cc32dcb6095049ed57560d99b409ba9297f4316bab551d05bb57ff355"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "44ee5b611ba15ea77174c0b4ee1896fcacddecc6de0a32b46b1cf317cfd56bfa"
    sha256 cellar: :any,                 arm64_ventura:  "688ca144703bf35e2bed5795e09ed9f51e31c873264f501f76ae3c31757060b3"
    sha256 cellar: :any,                 arm64_monterey: "25a6e61157c1b167be7f8d47f6fb3e565fe6f9022b1d5cd72b3e180008443d25"
    sha256 cellar: :any,                 sonoma:         "bdd98118c755ba68a7002ab29957bffabc63d30888e1d5be2d7448395e7dab7a"
    sha256 cellar: :any,                 ventura:        "0ef748e1bc21658f25a6a81d1f1c2835c980b0fbdb228f291b32ba609205aa73"
    sha256 cellar: :any,                 monterey:       "289571443a3f5d3d57555ef870c88893ed9dde465fecdad7991530831c74aac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "094bfcac7b0dd2e957cc65a539e8f669615300b827608c90d2cbc91741b03de0"
  end

  depends_on "htslib"

  uses_from_macos "ncurses"

  def install
    system ".configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin"samtools", "faidx", "test.fasta"
    assert_equal "U00096.2:1-70\t70\t15\t70\t71\n", (testpath"test.fasta.fai").read
  end
end