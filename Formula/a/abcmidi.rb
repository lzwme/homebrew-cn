class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.01.29.zip"
  sha256 "c1acbe7600e90ea5794deb3c9989cddaff64cb4cb97b443bbc98a2398f39da7e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7160d12c893c31d1964beb65a317006a4c8ca7aec74d45d32cd667d3e14ad335"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4afd5ac1c099fa388cda402da7c89ce98ad2016e15d9541dc78c32eb8656e04c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54bda8c5aaf9590e3a0a191eaddc4d23c89382ec39fcbf60686ae8a90dbe55c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "380376f0e8bd2bb842d464b9590d0def2222031a7d6983ed49a5561f520cae11"
    sha256 cellar: :any_skip_relocation, ventura:       "52065674d8ee51c7e7600afd3aef48e1483958b0bcabf3832b7533c21c5edcf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "521a6a0a1aa83f1bcf87111be5c86d9ac04e2f8e45d006a4c0fc68fdc4de418d"
  end

  def install
    system "./configure", *std_configure_args
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