class Bar < Formula
  desc "Provide progress bars for shell scripts"
  homepage "http://www.theiling.de/projects/bar.html"
  url "http://www.theiling.de/downloads/bar-1.4-src.tar.bz2"
  sha256 "8034c405b6aa0d474c75ef9356cde1672b8b81834edc7bd94fc91e8ae097033e"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?bar[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "0bfd47d83744c345b9d102b66f8f7f580757d90ec821789a76364ad8b1cb13eb"
  end

  def install
    bin.install "bar"
  end

  test do
    (testpath/"test1").write "pumpkin"
    (testpath/"test2").write "latte"
    assert_match "latte", shell_output("#{bin}/bar test1 test2")
  end
end