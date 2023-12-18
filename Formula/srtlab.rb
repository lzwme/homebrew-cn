class Srtlab < Formula
  desc "SubRip subtitle file converter"
  homepage "https:www.dr-lex.besoftwaresrtlab.html"
  url "https:github.comDrLex0SRTLabarchive0.98.tar.gz"
  sha256 "33af6b202e537316f2bab4b0709411ec3159c3dddb7f327497c8d9c32d6c9ea4"

  def install
    mv "srtlab.pl", "srtlab"
    bin.install "srtlab"
  end

  test do
    (testpath"test.srt").write <<~EOS
      1
      00:00:10,000 --> 00:00:13,000
      éâ blårg

      2
      00:00:27,183 --> 00:00:31,416
      ¡Dit is bról!
      Bröl brøl
    EOS
    system "#{bin}srtlab", "-w", "-u", "-e", "test.srt"
  end
end