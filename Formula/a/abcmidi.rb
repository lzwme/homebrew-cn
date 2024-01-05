class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.01.04.zip"
  sha256 "de6ac240ee02c6e67d1761977429f708bf46c484e286a86bbd712e46256653c7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfc4df749bd8028501c0e64d0835488964ec83df8ed40f7c596b7e8dd3420f75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c571a87fade3964cad198bc5ab871201c3dcd915261f666d514fb2de8d095535"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860f1bbc0cea54f7b00e0ffdc040f8d7fa2dc354d2f8b63271723833f99b1666"
    sha256 cellar: :any_skip_relocation, sonoma:         "c758dcf962a65b1d297c10b657335885f5b9185b64f1b4730967ca2498631b14"
    sha256 cellar: :any_skip_relocation, ventura:        "029cad50abe84245191b14303615368206204ec3e70ce78f6ae62e64d44ec506"
    sha256 cellar: :any_skip_relocation, monterey:       "83acc67b3d62201f99f4c6245ea18e0cc081f6bacf4a650694d31a344de62708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f489c8e15399ffd15c1dee753af91f72a95fa44f6c2e79b8d72f9f7066193a4d"
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