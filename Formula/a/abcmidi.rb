class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.02.19.zip"
  sha256 "a25cc835700f48f16203de83a0c01073254e485cf455db474379c25b69f9323d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b939497d05685de7de0133032331b0fe3cc490e4c3241cbf714144d5c90719e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f62ca4fd1bb040ddef9fa8f2063c042f8464291089ee4ba14e44bfe163764e5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e68987e9b6968a650df6d36516f58c537f4f6743a268f716dba6691545b0cc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "95bc12eff1eb040bbb3f3bf764e0aa5be2b02dff583026ff72791162e7044b4b"
    sha256 cellar: :any_skip_relocation, ventura:        "ab31c5ce43299c463001762799b3e2460bb5f0b5777d999c2832f2cb1c85192e"
    sha256 cellar: :any_skip_relocation, monterey:       "933f019c89c4c73900a27b9efdfba47f9d3ea6e5352b8e3e82dd003312111230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9899a54f1e95b469f4400eddb261e78ce4d19bb42a399341dd932e06d06f0689"
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

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end