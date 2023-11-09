class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.11.08.zip"
  sha256 "ceadf21ea7c8bfdfdde7ca67acba2ab7d396450a0046b12e06d82526893a0f76"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f7a73c4cf55ac293b8a1454d20521380306bddb260841ead38726a25ba0128b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "710b71578e9dd09d56e882f97ae5c95446ab0e82d96a21dc5ada04356b8dad90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b35d5ab63d40b619f652fc4b3c6cf287cbebc82228348c3ed1c453b6104a7179"
    sha256 cellar: :any_skip_relocation, sonoma:         "430dcd42ab0ac727c925f1afb35d18f01ad131dc1e53b3b71c9c57eb32d5772b"
    sha256 cellar: :any_skip_relocation, ventura:        "ce827b862282b73ee0f4dd5f2a45e6dae9845f968cba2c3ac5d7397a519ee469"
    sha256 cellar: :any_skip_relocation, monterey:       "44dc8b3a7d3fb0cbb98d6010f5600ddae38b37b4a72d9f930f46b89d83a7d35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "447b4cdeafb4a2c0703947299f7bdaee0132dd7bef38bb04ef5f963159b2805e"
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