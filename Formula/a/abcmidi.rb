class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.02.23.zip"
  sha256 "9e09a0653c8b66afb2d4ca4638234bc620cff71637856d7e5962ae1d450680ed"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f8220da274c7ea9452f87b0a6e16fb89640a64df3e2e90a6cc1c75036eb5472"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c25d1182318ad6b84a86b013d56763dc39f5da364be9c42c88f12379a56a4f56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09318335de432111b8aa22bc5b7078a3080256bea947a8c8793d91f00061fb64"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ec36ddb859054002183aa71a2b19feec7de45193b0cf5c4795d99fb51aeda6f"
    sha256 cellar: :any_skip_relocation, ventura:        "82947b8079d3bd9d2ccd8759adb5d50589896c78d77f1fff16880a9ad6e0deb9"
    sha256 cellar: :any_skip_relocation, monterey:       "13eff8f0aa869428a7a1a1b3d07c565359a2351841e6acbb1d56c4f15fc188a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2ede1e603e4bde5aadd2d45906b68856b018639a9f6a032d45fdd2afa47a876"
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