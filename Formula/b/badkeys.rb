class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https:badkeys.info"
  url "https:files.pythonhosted.orgpackages3f51e1acca1ebddf0dc44937e340690364051e2e79e6d4bd628aba9f30f56115badkeys-0.0.12.tar.gz"
  sha256 "2c80bbb84a39d0428082ee8f2990a91a6f30f6df85e9a75091c4a862c08611e1"
  license "MIT"
  head "https:github.combadkeysbadkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "495481caa2debdf89862b19893af1a4462b08dec6b36b23c4051014db5b8935e"
    sha256 cellar: :any,                 arm64_sonoma:  "c4a8709ae44d82257dd0b602374649c1f536aa5be1a9878f6103055df920f22e"
    sha256 cellar: :any,                 arm64_ventura: "a3c5815c227230de6adf15626b51008ccbd91c715bdb576c6ea22d7a8b98df0d"
    sha256 cellar: :any,                 sonoma:        "426d2bd679a81a323ee8e3ec5093365f205e2ff01a7cc9dddac72c4f0d67f8dd"
    sha256 cellar: :any,                 ventura:       "e350e6b5366ad217226580150b624d7eb859015fe47124e77acebb1d2bd82c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac37d3762c9eb6e6da7eaa5e0e62f2a22aeb7c2a8958b77d4ef3203da8bc8067"
  end

  depends_on "cryptography"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.12"

  resource "gmpy2" do
    url "https:files.pythonhosted.orgpackages07bdc6c154ce734a3e6187871b323297d8e5f3bdf9feaafc5212381538bc19e4gmpy2-2.2.1.tar.gz"
    sha256 "e83e07567441b78cb87544910cb3cc4fe94e7da987e93ef7622e76fb96650432"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}badkeys --update-bl")
    assert_match "Writing new badkeysdata.json...", output

    # taken from https:raw.githubusercontent.combadkeysbadkeysmaintestsdatarsa-debianweak.key
    (testpath"rsa-debianweak.key").write <<~EOS
      -----BEGIN RSA PUBLIC KEY-----
      MIIBCgKCAQEAwJZTDExKNDDiP+LbhTIi2F0hZZt0PdX897LLwPf3+b1GOCUj1OH
      BZvVqhJPJtOPE53W68I0NgVhaJdY6bFOAcUUIFnN0yZOJOJsPNle1aXQTjxAS+
      FXu4CQ6a2pzcU+9+gGwed7XxAkIVCiTprfmRCI2vIKdb61S8kf5D3YdVRHTq977
      nxyYeosEGYJFBOIT+N0mqca37S8hA9hCJyD3p0AM40dD5M5ARAxpAT7+oqOXkPzf
      zLtCTaHYJK3+WAce121Br4NuQJPqYPVxniUPohT4YxFTqB7vwX2C4gZ2ldpHtlg
      JVAHT96nOsnlz+EPa5GtwxtALD43CwOlWQIDAQAB
      -----END RSA PUBLIC KEY-----
    EOS

    output = shell_output("#{bin}badkeys #{testpath}rsa-debianweak.key")
    assert_match "blocklistdebianssl vulnerability, rsa[2048], #{testpath}rsa-debianweak.key", output
  end
end