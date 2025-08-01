class Potrace < Formula
  desc "Convert bitmaps to vector graphics"
  homepage "https://potrace.sourceforge.net/"
  url "https://potrace.sourceforge.net/download/1.16/potrace-1.16.tar.gz"
  sha256 "be8248a17dedd6ccbaab2fcc45835bb0502d062e40fbded3bc56028ce5eb7acc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?potrace[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "dec55e697af533180d68158fd557f596e65887a1e5043214dc0532464aa6ef27"
    sha256 cellar: :any,                 arm64_sonoma:   "003f7041bd6b4ea6de5ac2c8fbe9e2537a6a6dbd169f0c872627c5e2daa00afa"
    sha256 cellar: :any,                 arm64_ventura:  "a7201a2a7bc8af588056ef0319281dab31dd376af60a379430edc495eea29041"
    sha256 cellar: :any,                 arm64_monterey: "cc774c2a6d82a036c9ccf80ed467aabbf39697e8a36ef210cb5b793fb4b6be05"
    sha256 cellar: :any,                 arm64_big_sur:  "80d3d0256f9b7add7d3835f6c84f30afec6a4893f2fcd2aa44b07ebe95876c7f"
    sha256 cellar: :any,                 sonoma:         "84bb1788a245f7bbd5c2bb8adb2f4693c5ff4ca7a97dda75235be2d5a590106c"
    sha256 cellar: :any,                 ventura:        "a79629c4ae550b6894ce39a3afd6ed75063c885155bf44365feaa551c346e2ca"
    sha256 cellar: :any,                 monterey:       "2e65796f5e50c82a6b11475034b04f6a0647f044c5c81a819bb6b3e8f0d5e6cc"
    sha256 cellar: :any,                 big_sur:        "3b5294deed86179a4e496236fb882eb0b7ad3c020741e2a1398861b545062712"
    sha256 cellar: :any,                 catalina:       "c3f357a8bd6460384400acd00dab0d8571ad0b1543a81e5b9d5ff49d1ece4fa1"
    sha256 cellar: :any,                 mojave:         "3ad69cce4edecea6e5170b766201845b703a98bbac3c5272ef6a045f828643e2"
    sha256 cellar: :any,                 high_sierra:    "56d821a4d3579bedf64ebf5357fc04f214cb2efbea7ddb681b202e684e71d97e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1226c34ff1e1baf0622e69e59d69bf515aa1d6a8a6381b7c82349c4d578447d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47c98611b15465f29e55972018135927d42929e5901153ad99c6579de32863c"
  end

  uses_from_macos "zlib"

  resource "head.pbm" do
    url "https://potrace.sourceforge.net/img/head.pbm"
    sha256 "3c8dd6643b43cf006b30a7a5ee9604efab82faa40ac7fbf31d8b907b8814814f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make", "install"
  end

  test do
    resource("head.pbm").stage testpath
    system bin/"potrace", "-o", "test.eps", "head.pbm"
    assert_path_exists testpath/"test.eps"
  end
end