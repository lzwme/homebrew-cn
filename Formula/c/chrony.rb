class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony-project.org"
  url "https://chrony-project.org/releases/chrony-4.6.tar.gz"
  sha256 "9adad4a5014420fc52b695896556fdfb49709dc7cd72d7f688d9eb85d5a274d5"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony-project.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8dd39a73c72e5eb5a672b27116f0fd8f26fa0a4007ce2613be40def748f19645"
    sha256 cellar: :any,                 arm64_ventura:  "f32fd2718dfa16bafe27de82d88bd85e820342061a88b8122a1e0b50a1006a1b"
    sha256 cellar: :any,                 arm64_monterey: "771a70145c907d1f00427dbaf21b73eb18c8fee321910daca5c13de408780f72"
    sha256 cellar: :any,                 sonoma:         "246323fd8a3bf0207a1d00a3ed1b0a96b7d1b8d0d2abb91dc76f6beb557ea147"
    sha256 cellar: :any,                 ventura:        "54d5f0f621055661d0ae4c27a9288f345d05c4970a30e28ba9a41e436d1ebb61"
    sha256 cellar: :any,                 monterey:       "2847a89576282ed278e8045f8566c74eeeb9f2bed67ff0252324057960ecc387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf993c8b196e32abc3ea453038ea3a0eb7ec305e2fe0d1d9f99e5e8d26ac941b"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end