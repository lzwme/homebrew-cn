class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.12.23.zip"
  sha256 "b1f0aac805338c1beeca0680db59985e0a4922ce3cf012ac60010780789610d7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44943cbd6068cb14e6e98a2599132704e9f96d713a35021b81caedb131ec88f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef99eed5781b31ba746b17696f05ece03f539576f7f9af18620aac6012b4b9f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56a6b5f202f1ceb786a78fb7375208fc368ba54e8e493f6ee7a3353f38c329cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc57a7a83bc37b4bc09d09fb5f5eff0c0dc3ea6d435e0f41690a6f851f539a2f"
    sha256 cellar: :any_skip_relocation, ventura:        "b20aa427805e382d5831cbbf6bbb02e4b506e43c15bc4e1c8b7b19677c953654"
    sha256 cellar: :any_skip_relocation, monterey:       "605b6b9f4c953978e83c56291eef3699f7e4d212984cebd91b315f20cfbda217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03f686575c4b3dc86b55e5975d130e4e1a289e69480ca0890ffa2e89b721470"
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