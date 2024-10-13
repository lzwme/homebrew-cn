class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https:domainaware.github.iocheckdmarc"
  url "https:files.pythonhosted.orgpackagesb4f30e4108ec0939ed21524e8fb2638725cca48ae750a837b09d3f6695092419checkdmarc-5.5.0.tar.gz"
  sha256 "d775f566f8fdd584adb9a26e792cfe1565cdf6bd50c54fe7b6d8443ce6db68cf"
  license "Apache-2.0"
  head "https:github.comdomainawarecheckdmarc.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a9606704c0776409c67bed4b84f5a9b3ba213a8ca1d7740ec3e43db57081828f"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "expiringdict" do
    url "https:files.pythonhosted.orgpackagesfc62c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "publicsuffixlist" do
    url "https:files.pythonhosted.orgpackagesee7f6e5498685dacae497d6ee8c45cbe489e901b3ffbcedbe897e5a87cc4213bpublicsuffixlist-1.0.2.20241010.tar.gz"
    sha256 "a726d826bc3b6704995ce0ca144d87768060e18e1df39e6e57f2c645671c0df9"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}checkdmarc -v")

    assert_match "\"base_domain\": \"example.com\"", shell_output("#{bin}checkdmarc example.com")
  end
end