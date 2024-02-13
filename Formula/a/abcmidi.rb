class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.02.11.zip"
  sha256 "3dbd314f276c87acc50a93dc74da6cf07d679957232111158c99f6d234ebbc84"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15ed174ebdd3b26ea2cb9ca45aebb38b653af009437f0e257d648247215688b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ce3da0ccc45fec36d6918d19d186378e76de304a79844ca47f5c8e099d53863"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b033e01367f9e6df7f34d8b04fcbac51c787ee73f1d1f7eeb1406c3303dfd99"
    sha256 cellar: :any_skip_relocation, sonoma:         "76654719753168590d7d6dc77179897577ee4f768e3814897f8754b0ccb21f55"
    sha256 cellar: :any_skip_relocation, ventura:        "6747d85c8fdfcccd893f6eb44a3f2773bbe03e7a3ffebde503a463341f76dd82"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b94f662dcc97e4a70a19ac8c65279a9635be74b7ea082323bf69136c9986ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f665ddd320c834f79f9f0e96d3c5ce4a2a2bfb71834c70753e862a327933b3a"
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