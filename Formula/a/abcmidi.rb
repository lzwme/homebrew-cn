class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.08.11.zip"
  sha256 "cd13edf91b48662551d590733a38477ccb8eeedf7c03e46ec3e3eee2af8935d7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "720d22d768630d678e57a6e43433d5c92bae858d05a3dfde1675df8899507021"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d107c14343858a9ee28980c49d592ac39c0aaee4756ab57f9a6127cb0967a01d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3e2f761af8025b526ca809e02420da1281d0541937ce95c08be0d92013d4c70"
    sha256 cellar: :any_skip_relocation, sonoma:         "5803679fb616509967a8b2d63e615d4fd77ca2a04b5afc33e4036b5760ddd9e0"
    sha256 cellar: :any_skip_relocation, ventura:        "1ab7f03c2c2616db5a275f7a920c44be39278ff753d03fce726b1d90d97c13ac"
    sha256 cellar: :any_skip_relocation, monterey:       "470deda3d4247b658f09424c3a75d7d149f4043a567bc7e425da25341d0e29d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dc7683cab03f8fcef2436303ff306ab4f475d557379a0b2b564d907abe6b6ae"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<~EOS
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordion
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system bin/"abc2midi", testpath/"balk.abc"
  end
end