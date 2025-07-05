class Srtlab < Formula
  desc "SubRip subtitle file converter"
  homepage "https://www.dr-lex.be/software/srtlab.html"
  url "https://ghfast.top/https://github.com/DrLex0/SRTLab/archive/refs/tags/v1.0.tar.gz"
  sha256 "3a1fb77163003184af06ecb4ea67d5498d43729ee1018b66860ab11a94628b6d"

  def install
    mv "srtlab.pl", "srtlab"
    bin.install "srtlab"
  end

  test do
    (testpath/"test.srt").write <<~EOS
      1
      00:00:10,000 --> 00:00:13,000
      éâ blårg

      2
      00:00:27,183 --> 00:00:31,416
      ¡Dit is bról!
      Bröl brøl
    EOS
    system "#{bin}/srtlab", "-w", "-u", "-e", "test.srt"
  end
end