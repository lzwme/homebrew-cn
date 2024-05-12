class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https:badkeys.info"
  url "https:files.pythonhosted.orgpackages4193d101028c62f0dfb853715388dab374b36089d21a7530b91d4f6f46a85221badkeys-0.0.10.tar.gz"
  sha256 "2d31b77c789508b6d810b8d1919ffea08547d6913b7917c247967c921d60646b"
  license "MIT"
  head "https:github.combadkeysbadkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6acbdae2666474f8a2225214f1a9d9da69d5749721c429c6a25306d0a54b432"
    sha256 cellar: :any,                 arm64_ventura:  "538357ea3fcded9495d4e17287e784ba437ce486641c4ce067ed834fd23973c7"
    sha256 cellar: :any,                 arm64_monterey: "28a933cdab260c3ad593f8db5667e8afad1a41815480e0f199d9c2d2334aff8b"
    sha256 cellar: :any,                 sonoma:         "5f5d7cc5cebdf2f76abb3161725a3cc883fed3cc862b8e3e84e40aadcc4c1000"
    sha256 cellar: :any,                 ventura:        "e332aa6cbdc549162706981bc212841d2f65cbb5e07f6f2036ca6e30ea5e50de"
    sha256 cellar: :any,                 monterey:       "3212b7531aa42c95745b099d5c97e74fa1a4ff0bcc14b34e303da04ae4854ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5545ac435000ef586fccfac67727c103641064b6f8616fa895861c25988db969"
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