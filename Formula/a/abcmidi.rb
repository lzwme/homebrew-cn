class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.10.25.zip"
  sha256 "8e16012d3c6e6e5a60541cdc1f299d3df3404930d4fcc4cd556eca9ddc6779b7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb502b35cdaace11e796a74369126841c21eb488b4a783dd9b433a91a5e060a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ac46f51beba4ef1d475cac92a3f577be38532904df045cd5803a0438a5aafdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0496834b7734a691cdd10ebd7e0d93989c75bfe535949c4e5345ba3e1a89d455"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb74a076630bab07efa63cdec95862ba2efede895ad9e37c5cff4e1051e20926"
    sha256 cellar: :any_skip_relocation, ventura:        "8d9eae914f6ac9f68cbc4df774f9ef7862cff1de9826ee3c6ba109bc03011b00"
    sha256 cellar: :any_skip_relocation, monterey:       "f2f536c1e536e3209e9b6b538bc1d5fc26d98f23efc2503b6c3b22e49ed28583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdbf07dae96f060fcd43ce508d49ee29ee58ac013865c7aa49bce9b6edf5f997"
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