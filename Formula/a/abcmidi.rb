class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.05.31.zip"
  sha256 "cab98a3a9b3ff1e8ff2be3cc8e70ad87e425198beaf45754ce205d2a5bb3684f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17e189f54997240ffa629dbd44d819d3cbd335f6f6e75c42428fbd8b00be2014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5c3a6573340b2201608a5e3aa3a53b864e276c513ba673fc2d40b535a6375b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76f8bd2760890b275d0158f24c40249eb3ef2e54cad166bb1e02fd0847d1194e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f84981d255734fc72c6c68b77539ac6c8d1c171f52b278d3e25183f34fad2617"
    sha256 cellar: :any,                 arm64_linux:   "08d38590efdc1f5a6d917d3d15d7604c2fe5d5f2ff5d701d4bb26145edd14010"
    sha256 cellar: :any,                 x86_64_linux:  "c23bd5e44ddaa376a8a84d66b7b57914d1e0b8f2c822ba3e881d1e510ab6fa41"
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