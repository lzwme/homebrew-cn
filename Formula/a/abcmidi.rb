class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.06.14.zip"
  sha256 "7ea56ecce013b0302618db40375eada3d55cdb87349f80f60d8197f6f24a223a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5616f59e2e68371d5ba7b4c07368ed1a029f041e20d4d0746ec230a47be2278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0358d58e1fffa5cf52a919b5fa699a147c631b94369671fbba3e1bfa9d5f8597"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "421ba9e7582a3df8094c75c8492fbedd5e1fff32b345bbf0298d0f1571270617"
    sha256 cellar: :any_skip_relocation, sonoma:        "e190f086c82c9fb5010ec5fa896e3d1f280ac3b06b07d87343fc4de621d1e148"
    sha256 cellar: :any_skip_relocation, ventura:       "deb70187cc2b85cc479142e09003541dfee9cacd3793d96f0b16c612e0402132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "744e4e4b99db80e4acf809bbc5268809148bdd363228aaec130d88ce27c843ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2bbd19b0a51fe1efc98d87593844d87d276e3115a09fb002c15f59a647f9c58"
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