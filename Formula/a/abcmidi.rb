class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.01.13.zip"
  sha256 "619eaecdac956e9e148504cb370f047955250b43a3659d1bbc5562d1105bc5ee"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5affac3b910c8396b75ac5d5abfc280c8b381773cc77a7b8991fd3a903fb3d27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8017e99586b962ec56a67fc5116bb8005599799f647cd5c059400fe0ae17ed93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e77c3ab9e33ef92a4a16ddd13da760c61fca1ada2b7d287e284493860fec1528"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4459d4a6ca24f4f4ff81011687d6233d0cf678f3267ba11a336c6552d92c03d"
    sha256 cellar: :any_skip_relocation, ventura:       "a05eb9d2a3965a40608af9e3ae7e428b7761c6290eff5a3058cd3476bc73dead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d753cd22c36bfed2c113a770e1c35e3cc82f1893c2abf3a12c92ff13c29d462"
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