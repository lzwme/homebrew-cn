class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.08.22.zip"
  sha256 "7a8cbda431baec0ec55a1bdbd0a6868a02158c9cdad7b306d6f2aa7119eb0fc0"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42210650af8a7396e17e5eb2e8bb89069b8aa1bd43821bec94f6c4fbc7eb3a63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90c0dd95a199a9d8f7e08887dc111bd2332cf31ea58dc3f3fd1a8d57b15c9d2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35a060eb81e0b93797a0f24f29d93e4edf5bde783c32b7a2d075873fc4578323"
    sha256 cellar: :any_skip_relocation, ventura:        "4fc2b6c80c687d6276251cfaa4b74ef25ead4b29ee98949b946bcb373bad9bd7"
    sha256 cellar: :any_skip_relocation, monterey:       "e5991603f459aaefbeeec039e9c760dccab7dd166c8da31dcc563735d2a5f7c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "27a4543c5569c3dcc2d848eb5142cb0fc47165b99844d99f3e3f19685e41be1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f8394ba146be1b362a836146e636804cf306656910d56df931ecf3fdb28f74"
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