class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.01.30.zip"
  sha256 "09ade220143e79c8f1f894c4b2fa6b00fef9cb02049f35b260b40c5960bef922"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e23579f62be2ce39d1a955b7091a24998f207d8c2903e0e3e0aa29c3c47f071b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8ea5bda25088c0a027d0017b2d38563e66bbb8d0fd9f22dfc4e6108dd644cc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d49188390fdc6167b29929b9a9fa55bae4f92cfbedbe2f9f26fd2490cc378a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa0d61ca67c9b0f1628427c204d4ccc74fa2c82648048257d4de7350544513b5"
    sha256 cellar: :any_skip_relocation, ventura:       "d6ec1aa137c5c5650a378452b66bc1c5df26d97fa73507856accc4f28bb1be82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6cb4ef0e67f7228701dfe0762995308261c16fb7372f73dd89f75f79bd1d267"
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