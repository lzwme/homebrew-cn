class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.09.06.zip"
  sha256 "a64581d26a0c4a1bdb3189047782865f20ea7f82a77bcb0d474d0df10c773f11"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f23bba05e2f51d2e3fadbf2293e74f2f7e5705a3d3f46729b253b5bd864f220a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a2ee72db709102f50efeb8f1966ec225fc062b485dbccf520ba6b7b2e249ce7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "861775bd4a2416b8907ab3e957bb2065d7f8a0a337b286b206ba2a4e07c638ed"
    sha256 cellar: :any_skip_relocation, ventura:        "091b8a99116ece161f85d6c12899f7908e25452ef9dda12f06b39f850e27c571"
    sha256 cellar: :any_skip_relocation, monterey:       "a97d625c9f043ca62496d820722553b56eaebab7d176fdada2d51b3b8e415fe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "76c5c528dc35dbaffd7d483e169c128d577dec2a3673610d7289722abb0bd680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27d518ea84baa1b79ed3bb755e21fb4be982f56e9f9052ebd287be85f32f3061"
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