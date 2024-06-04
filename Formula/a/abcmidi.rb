class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.06.03.zip"
  sha256 "22de1b4b3c93bfc76be9a5ebf22901023608e788114c7ef42d435527a212373f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0878ef4a2ff644d6adf0b94b5ccf7885f3ac06721175c86fad5a024aaa78038"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1978827fa207d7271ed07d7058d528e17e846d69097e836248f029a75754048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf28058aea784cdb200655a84f9baa4ec84bc70b145b9a3cfedb7c7b0e05dad"
    sha256 cellar: :any_skip_relocation, sonoma:         "57e59f7c844c42b44d85195d70b2f49d111936024525f3dedac9a82a45b4237e"
    sha256 cellar: :any_skip_relocation, ventura:        "e32156ba20c791b14042c08e4fe09f46314e442e4586e1aabcc9fb29fa9d39a6"
    sha256 cellar: :any_skip_relocation, monterey:       "2756f8ef235bcb1ee79d200edd00cb2149d123366d9a8d9ff736b6159a72a854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "173c2484e24a905be84cb6c72646f77132b0f3ff38f8d400974670e65635a086"
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