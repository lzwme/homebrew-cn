class Sslscan < Formula
  desc "Test SSLTLS enabled services to discover supported cipher suites"
  homepage "https:github.comrbsecsslscan"
  url "https:github.comrbsecsslscanarchiverefstags2.1.2.tar.gz"
  sha256 "c218d21fdf0b57dfc7c7b110ff32d9c7e77eb8c631b670a2c0fc92a80ded294d"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https:github.comrbsecsslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91e65ff070dca7b5773b4bdcc7ed3de0ce50d908687216ed0daa6563d8b8bc17"
    sha256 cellar: :any,                 arm64_ventura:  "e1416f22475be6a61f667231fb8625d366475446afd8af4108df804af61c30a1"
    sha256 cellar: :any,                 arm64_monterey: "57bb73e5c267f319e6c7bc5db646061202ee3a483c8f03b2555100e21fd2e3cc"
    sha256 cellar: :any,                 sonoma:         "5912296ff6ad719758a1aacd0bde2bfa6e09d49bf443005afe6cac78c9b01b0b"
    sha256 cellar: :any,                 ventura:        "7eab4640e8cb714a9f0a025537fc14e6fb135938be0afeb2f15f4da79d23e583"
    sha256 cellar: :any,                 monterey:       "13b8c4d0624ff2d43fd5314c06211549242f0a83a31899756a9f74e8f0316d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71e9ea4dc9b5e68ad9d6687f15a8ef298737441c3d10913a8f459895c2f254bf"
  end

  depends_on "openssl@3"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sslscan --version")
    system "#{bin}sslscan", "google.com"
  end
end