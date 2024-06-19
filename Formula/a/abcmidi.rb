class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.06.18.zip"
  sha256 "550e7c01a15983b1dd621e102b8b2385323ee5bcabd582aeb63396762b9f0917"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7354838b3f1ce12b9571a05e4b22ced2500eeefa35f5588e1838a9d7e57d0ac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3d7e6b5c9c2759e56ae5941dfa3a794ce0ca73ff2224930cdd94dbf22220a1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "998947b57c8e7bb0f2e08e9404bb79cda02f3c00817a914db6d533272ee6c4a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "730c104dc3cd3e186bfda0e125e0be0d08d69ca30c1f08bfdb6635ff3e19fec5"
    sha256 cellar: :any_skip_relocation, ventura:        "ac43bed9c845f6e8d754df6fc8fa06e4354b88c6a6e587383f309d2b517bc0e2"
    sha256 cellar: :any_skip_relocation, monterey:       "010c144d71bd0686d46f0b3363500ae39b3853838fdfa497e77bd89d766c7245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d5f1a481349a0726da25ca189581744c7440d1004254d50a836be9c4309c8b2"
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