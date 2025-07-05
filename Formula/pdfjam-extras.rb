class PdfjamExtras < Formula
  desc "Wrapper scripts for pdfjam"
  homepage "https://github.com/rrthomas/pdfjam-extras"
  license "GPL-2.0-or-later"
  head "https://github.com/rrthomas/pdfjam-extras.git", branch: "master"

  livecheck do
    skip "head-only formula"
  end

  depends_on "pdfjam"

  def install
    bin.install Dir["bin/*"]
    man.install "man1"
  end

  test do
    system "#{bin}/pdfnup", "-h"
  end
end