class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.07.26.zip"
  sha256 "30a41811e3505c1ecb4ede75e268b3552144dead0871d1a45ca0a64531185898"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb9a6c31accb16d59293d20bdae402f346d6cae42a1e2c6cbaab36f7d28ca967"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a968a26d5418883fddb42f8beec50626b240e5ac3fd42b94a0c3137fcc0db65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaede48f40410de7ee8febbbbcc4afe2f68e9b2b9c8bb71010823373c59c0202"
    sha256 cellar: :any_skip_relocation, sonoma:         "e40c52e92cd10ec9d0b626d577694fe512202ba2d0ac093614c9266820bb0219"
    sha256 cellar: :any_skip_relocation, ventura:        "ee457be486506b3d6d2de853cf4894027bf36ec1b28d9f62caee3b6693a24f47"
    sha256 cellar: :any_skip_relocation, monterey:       "63dfbab7cf9bdb12a0c20fdd8e5b33ce10c5833b67f4b411c4749316e57f826c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39fe3d4c7951ddfbb4cc9e19ae1fe07877891094f444e238eebc7e4eccf1ef3f"
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