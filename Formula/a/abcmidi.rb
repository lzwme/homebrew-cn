class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.02.15.zip"
  sha256 "4137c8ac2d9909137f2900638097f9209b910c67c2728d980ee753b1f86a60af"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9697daa5ca75d32612b52a08ec29256df8cacbf19603399c2f9771b3d431b338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "494faaa8843bdc41bcbd4eb54b1fce2331070f1baa9a517b52f0fa018fd5e28b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c16ddf83cf415e100ecc69164131c26bddd18ed90ced3326b3c7fced45300368"
    sha256 cellar: :any_skip_relocation, sonoma:        "418d5fc9638f8e248a94c345846a4346f35ec2dbb6e0d3e151781af3be653d13"
    sha256 cellar: :any_skip_relocation, ventura:       "46590b1ad05486aefb870f600d547a7d3b87882f190bfc175ee5084eb484c9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf377defc93eb43f1246df8f2ce55de503ec6035c7d51d50a21e166d7d8b7a1b"
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