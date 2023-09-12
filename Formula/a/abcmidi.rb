class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.09.11.zip"
  sha256 "50dc43bede6ce98d13bdb7e3d2b51921d9857b2e3b3529f3e57ed828160b6496"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "befe297b31e346baefe656ebd34193082c1a71bb228f21b2a8bb425819a4b749"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b631923b4936ec8249a7d9b71d1b06ba61a128adca3ebc1f52949ace3bffdfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "defd0e1d21098676cd37e0886749b5ccb8bbd47e1af244f7e857569b19f4894f"
    sha256 cellar: :any_skip_relocation, ventura:        "8c6fca3fc5db160bd46a403887d03fefcab1a3a2b8d6c527adf8ea67d1a13731"
    sha256 cellar: :any_skip_relocation, monterey:       "305817a9133928b6cc0ca1fcdd18617c12e2a1065aac613c594e11196d65e585"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2543d6ba8735508877c881cdd920e0694204e276ace3af9f43635063d880776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c523d26eba873112d51691bf7c21293ca0854201f0b136b7df4e678f5afd4b8e"
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