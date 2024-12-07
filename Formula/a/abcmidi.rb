class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.12.06.zip"
  sha256 "c7fb96b8a1a8871ac05f2f37a039dd7f9b1b79cc4e5837989790abd581de8cb5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8e86f3e36f367cfb90d90349079286ccc929dc2b6aa65c6f144593da8434924"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee81b7e0a38b16203b3c5838552d3b869c1802cf82bc052950f2cda8a387911a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c11718b8fc31f9b337ef212244455fc2745eca98b6a13b2eedbe1da61438ec5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fefdca4d12faac94451da6c42a5b93c5bc90627db968b29f3e8731eabd4b6dfd"
    sha256 cellar: :any_skip_relocation, ventura:       "37416f13e50b68b060d5be287217e79341625d3e5645d4bb84527787bbd0743c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28452206a92b7a012677c0d6f0b0897aac3e0f7b9f1a436bada001fcbf35520f"
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