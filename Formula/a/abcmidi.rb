class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.06.17.zip"
  sha256 "d8b0786d6dd4030c4091de956aa5341fa9d1c4fc8190baf0c4b739ae0d00cce8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2654d0b066442be566c5485aa3320a74cdc8ddb73bfe9c68ec82dff896f9aa5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96045430a13b5e49cd772f319cfa65a1f1087acf723a52dc0397e02f4189c210"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "829435600ca4d0cdc893dceb6ecaf066b06a6e1642af86dd6fd748b2eaf5e0e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "009f4695d8df6dcb9badec418541956542106d9782348e1f12589705eae77085"
    sha256 cellar: :any_skip_relocation, ventura:       "5fa4c49c2c2901379e98cd06cae4d1680d73b11489b666fa4b9f599a94493222"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91bc9f54ea631248c74ff72b392692540eae721651e30e0726f2804f07cc7c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5acaa70bf782313db78fdbad5c93a283f0c1f118037056cbc9895e35c4a37921"
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