class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.12.16.zip"
  sha256 "9c1045e7c287ceca6aba9a0fa0d2c858d99694c652a18500b82f29219d2fbb6e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd6e611964d3ad1b001b7a680941b75c5366dd44cfe90165bf736182faf4fc5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f53145f35e3e2a9a4ce70239e70d6ebd5189015df6907b6b1c8f44809097fa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6e1b99ac5355ef78d72f755e96790715ad8a2c0df1b11ff6692e42bf81cb425"
    sha256 cellar: :any_skip_relocation, sonoma:        "dea025edff8484b8267524d173ae0bfa5b14ec1a252cb08c5655eab440ef8d4b"
    sha256 cellar: :any_skip_relocation, ventura:       "12e2f2ddaa05cd197d0b378d8ddde10190d9b2fe6dd745461e1d768917872bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65faed698bee3d03ac13e17cd4bab95ff1dffed4247b5e70f46077a7896c710d"
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