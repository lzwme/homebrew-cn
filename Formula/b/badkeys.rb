class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https:badkeys.info"
  url "https:files.pythonhosted.orgpackages1a75598b292a0ccc7585a8b7e2a93403e2f6f00bb21bfb20a364db39fbf0f1d6badkeys-0.0.7.tar.gz"
  sha256 "49d6c417adc1c9c76784a0d3b1b29c79999243c8027f72e7bf33032596e8d0e7"
  license "MIT"
  head "https:github.combadkeysbadkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7ea280366fba3f17ae800e82f5575d4339371ec2d4672a7a5f906a8d1222aad7"
    sha256 cellar: :any,                 arm64_ventura:  "176e0e9b94dfa6b9f5500630156a0f7c63aaec544e19800228df18d9dc8c1a29"
    sha256 cellar: :any,                 arm64_monterey: "6919401a19c5483b7dece7e41cdf7c1681c36e46bc215e443f4fbaecdcb3ed6f"
    sha256 cellar: :any,                 sonoma:         "a63af4ad844369a9d9a83ed91cb733e531a6542a18c46fe83a119b328122f8df"
    sha256 cellar: :any,                 ventura:        "63a978d2b0cddfe1b98f593c9220cf78fe633dafe3e1078a418e8fec97a732fa"
    sha256 cellar: :any,                 monterey:       "485593241594904e2959a90cddf7177bdba83a02d58366e06863f3f5403e93ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1cabfae78a7a12e0f1d300283c836c9df90f61712185659ebf7766c7199eaa"
  end

  depends_on "cryptography"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.12"

  resource "gmpy2" do
    url "https:files.pythonhosted.orgpackagesd92e2848cb5ab5240cb34b967602990450d0fd715f013806929b2f82821cef7fgmpy2-2.1.5.tar.gz"
    sha256 "bc297f1fd8c377ae67a4f493fc0f926e5d1b157e5c342e30a4d84dc7b9f95d96"

    # upstream bug report, https:github.comaleaxitgmpyissues446
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patchesd77631527c866bbd168f7add6814e3388033cf2fbadkeysgmpy2-2.1.5-py3.12.patch"
      sha256 "6b0994285919e373d2e91b3e0662c7775f03a194a116b5170fdc41837dd3551e"
    end
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}badkeys --update-bl")
    assert_match "Writing new badkeysdata.json...", output

    (testpath"rsa-nprime.key").write <<~EOS
      Invalid RSA key with prime N.

      -----BEGIN RSA PUBLIC KEY-----
      MIIBCgKCAQEAqQSg27883tGr5jtyOaZkEn597cuw1Wz4wWuFp1quvHOyiMId7L7m
      KHh2G+WQaEEBKl2AMtXgdfbrY0NnW3SMIZ9PMTWJNjtAqjBKVBDXDJbJhOpvya
      gL4HBKR6cnB0TE+3m0co6o98xRT7eFBP4V9WyZYIG15XDruFvGkgeqmXefqf5BB5
      Erquu6RePYNt25I3SFM12kZTW+HcrDyj34CO4Jxkw5JI5bUtP9wV5ocrZ5FmvmI
      Di3eNbHBVteLN3BIuFax8JQvpcdwEjy7Qdro5Ad3a3Ld42VnmAkGPopHmJme
      wI1poiKh+VgF87bloijO+izBYkeo9ZWWQIDAQAB
      -----END RSA PUBLIC KEY-----
    EOS

    output = shell_output("#{bin}badkeys #{testpath}rsa-nprime.key")
    assert_match "rsainvalidprime_n vulnerability, rsa[2048], #{testpath}rsa-nprime.key", output
  end
end