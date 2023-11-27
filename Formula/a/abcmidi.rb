class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.11.26.zip"
  sha256 "21037782b87d1c7c636a6393f26fe402446b984db5d14eb65178ab252669bbf0"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5f8fdff50715c066d68cee460493f90ed5fb452de8265c561d9f3e14f2443ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8073a05483a57943eb0c17dc9cf8abe04e6e0ef1e7bb007da09d811540699173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffc376a93760a7d25cd1f213d994aff51ade40cf554a8abd543c02bd750185f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbb334f98bf3cacde263d3c7f35e41cc1ef8300fb71e8afbabc44ccec3465e5d"
    sha256 cellar: :any_skip_relocation, ventura:        "51bbfa904c50da4508c713952d4b544b2e3cec12ce220bce1054476ac84ac000"
    sha256 cellar: :any_skip_relocation, monterey:       "14ca65dcfcfb521905f37d8ec39ff9637e46814cb211b7e4b26bf61596708fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bab42d1a78868dd88758666f1176bc5cbf2d9d4c304671cd1b73315d9a42e3e"
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