class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.02.07.zip"
  sha256 "6df79b6764d391277bbea925c5fd6c5aea383c7d80855552bdd53fb4dd0d743d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e40d7dbad98b5fd02aa5e5bd5e3797ef6f7f6247ad32da9e343b15faa00c05f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a1eaee4c2ed56214517c9975e9e44758f6f219d295ec730ba018df86ae0bbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25f3e3ff5069578be529e5fb17caf99b3df6fc51bd8eb26badaeb47a81baa73f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd7f9a3c792c7ab4c6e9ea30d76fef4f00efe54f54172a6666559400f98e05cd"
    sha256 cellar: :any_skip_relocation, ventura:       "ae02d48f6638726bcd66b79c05f3cd25caecd7c12b0248e7abe11f3717819c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "792cdd01d9cc14c2116b23bcb66b297c3400fe317f7d6f4be75f7249f91a4f30"
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