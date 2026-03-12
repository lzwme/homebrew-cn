class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://github.com/ChristopherHeng/tofrodos"
  url "https://ghfast.top/https://github.com/ChristopherHeng/tofrodos/archive/refs/tags/1.9.0.tar.gz"
  sha256 "f4e16646a1eca631cb0ba62440b47cb8651ce1e6bd2982e8426d3a98ad8083ec"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07b62a45db3e96d8c124a399d4423631d0eb8161a1c60e90720049bc7b432b7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf5149e273342d3b3bf5fe9c23e13232c44242720373c1149329c89f8eb2e18c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd90aabaafa310b004b5b21bb0cb0f4b25b2d276aad5a3495661112a6765c258"
    sha256 cellar: :any_skip_relocation, sonoma:        "41949c0a585cd9cc996d4397f9373f616e36a60d1f17f4b5605482b2aa02788a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e00859f93c7110703d8bb47a72f3a833ee22a85d1440d89230396caeef0faa6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7fcfcc80b11daa6dbe5d4658ffd01534fc61c8705bd78411c9405c945954626"
  end

  def install
    mkdir_p [bin, man1]

    system "make", "-f", "makefile.gcc", "all"
    system "make", "-f", "makefile.gcc", "BINDIR=#{bin}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Example text
    EOS

    shell_output("#{bin}/todos -b #{testpath}/test.txt")
    shell_output("#{bin}/fromdos #{testpath}/test.txt")
    assert_equal (testpath/"test.txt").read, (testpath/"test.txt.bak").read
  end
end