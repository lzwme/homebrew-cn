class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://ghproxy.com/https://github.com/rbsec/sslscan/archive/2.1.0.tar.gz"
  sha256 "3140af055f067411a726f1061d8d7fd79e08fd4286e228dc3a230067b5704a72"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "654c52413c4eed54af47a6a1a7f02eb57101a157c02be1f2e735a6ed0b0b872e"
    sha256 cellar: :any,                 arm64_monterey: "60efae2ce409c466dd3f6191060331005f2ff56a83652c3c2548bac24cb7d0c1"
    sha256 cellar: :any,                 arm64_big_sur:  "c0659f9c851c1e395f7fb7a5cfe82a442df32c55d32bdf42e5cd1f4e73789e30"
    sha256 cellar: :any,                 ventura:        "9de248d12eef61db5c8fe80ca69dcb95c5c707675fb34467f4782354360b2a55"
    sha256 cellar: :any,                 monterey:       "aea018d1969ddd31785c812b91847638e0fe4d3506154455a744b1d0da54ef36"
    sha256 cellar: :any,                 big_sur:        "de0d240d76af747550927be683f27624cc03613dda2cf9506eeba7bed9dbd0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9d704b195a308aefcb2387fb682ba0056277fb6c2455fb38d0c36769dac16ae"
  end

  depends_on "openssl@3"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end