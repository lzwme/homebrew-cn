class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https:domainaware.github.iocheckdmarc"
  url "https:files.pythonhosted.orgpackagesdf06e61a492a70a2126ac62fea72694aa0ce6f645cbe44ea513d9a68e2df822bcheckdmarc-5.3.1.tar.gz"
  sha256 "1d71e7fa611fa8faa36fad09416b5e2c3265d026d3b5209c051f4e292565e332"
  license "Apache-2.0"
  revision 3
  head "https:github.comdomainawarecheckdmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "735f6a321f9a8082ba49f69591e350912b4a15391c5786f253b1f0e1e6f1e8a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "735f6a321f9a8082ba49f69591e350912b4a15391c5786f253b1f0e1e6f1e8a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "735f6a321f9a8082ba49f69591e350912b4a15391c5786f253b1f0e1e6f1e8a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "735f6a321f9a8082ba49f69591e350912b4a15391c5786f253b1f0e1e6f1e8a3"
    sha256 cellar: :any_skip_relocation, ventura:        "735f6a321f9a8082ba49f69591e350912b4a15391c5786f253b1f0e1e6f1e8a3"
    sha256 cellar: :any_skip_relocation, monterey:       "735f6a321f9a8082ba49f69591e350912b4a15391c5786f253b1f0e1e6f1e8a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f1715c1970a80f4797e6a7da9c35a68576f074abdcbce1f85dbb112961119c"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "expiringdict" do
    url "https:files.pythonhosted.orgpackagesfc62c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "publicsuffixlist" do
    url "https:files.pythonhosted.orgpackagesaf573ea928fac754715161b13560582e5c46e9914880d211e9caf3fda91ef930publicsuffixlist-0.10.1.20240616.tar.gz"
    sha256 "7d598406bf689ac09e440b1a3d4674ef2d629ff6f1ec97861c83f0ac1c46a58f"
  end

  resource "pyleri" do
    url "https:files.pythonhosted.orgpackages936a4a2a8a05a4945b253d40654149056ae03b9d5747f3c1c423bb93f1e6d13fpyleri-1.4.3.tar.gz"
    sha256 "17ac2a2e934bf1d9432689d558e9787960738d64aa789bc3a6760c2823cb67d2"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "timeout-decorator" do
    url "https:files.pythonhosted.orgpackages80f80802dd14c58b5d3d72bb9caa4315535f58787a1dc50b81bbbcaaa15451betimeout-decorator-0.5.0.tar.gz"
    sha256 "6a2f2f58db1c5b24a2cc79de6345760377ad8bdc13813f5265f6c3e63d16b3d7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}checkdmarc -v")

    assert_match "\"base_domain\": \"example.com\"", shell_output("#{bin}checkdmarc example.com")
  end
end