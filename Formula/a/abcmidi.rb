class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.11.17.zip"
  sha256 "350f7e579abc4abca630e20826a185489508f3ebf4caa5de21ff189931d040ed"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c96f97ccd8f7a02d525107238fc82cee0aa861b974fda2ee256d214df1054815"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99bc8d97825c283e79c4831a6174dd74eeb603086c637ff008edf8d4849caaea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43e469c960b59db83a3beeec2ae479dfa40eb0c7ba18484cce012874720431aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "aca9f1a0b35163983bb777df7c20f9c08474fc1a01c7a43a1679cb9059b6701e"
    sha256 cellar: :any_skip_relocation, ventura:        "731d6db2654f79c325facf307666a402e06b6cf417bcb3a8554140fd4f36122d"
    sha256 cellar: :any_skip_relocation, monterey:       "060e8c0cf9691907e88fdc9f939617224630b7e106c8b5de6757320c78ccb978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55d1923e4f21491e955dd430946f6c774856b540f663bffcc1066dd84e466d17"
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