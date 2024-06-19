class CloudflareCli4 < Formula
  include Language::Python::Virtualenv

  desc "CLI for Cloudflare API v4"
  homepage "https:github.comcloudflarepython-cloudflare-cli4"
  url "https:github.comcloudflarepython-cloudflare-cli4archiverefstags2.19.4.tar.gz"
  sha256 "7a3e9b71cad0a995d59b0c3e285e1cf16bd08d9998509f44d7c321abe803d22b"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5cb584e79944dd6ea01f0aadbb6703ded8d1664c7677c768afdd6f838a5c2aa"
    sha256 cellar: :any,                 arm64_ventura:  "713359996608bb858f97987b3acea28592a9a479147ab3e493b27a0dde07f88b"
    sha256 cellar: :any,                 arm64_monterey: "d3e173833ce6640624023365df93131ef4936e6af337776ac2cf57f4cf104ce7"
    sha256 cellar: :any,                 sonoma:         "57e3b9e205499029023ba49c72e2d57b918de8adb1815a143e0f8948fc7c5769"
    sha256 cellar: :any,                 ventura:        "ba0cf1bb0e68e6b1a40c4a6b744724aa129aee77b9b436b8467ccba5f7d912d6"
    sha256 cellar: :any,                 monterey:       "1b678743a85101ddd67e88c3738cbe960b96f599ba9c8a15215b2b3069aae6e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab9f57752201613b11989d7435cc8e313c1861c6dd30c6b0efaa832ac6131f16"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackages07b3e02f4f397c81077ffc52a538e0aec464016f1860c472ed33bd2a1d220cc5certifi-2024.6.2.tar.gz"
    sha256 "3cd43f1c6fa7dedc5899d69d3ad0398fd018ad1a17fba83ddaf78aa46c747516"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jsonlines" do
    url "https:files.pythonhosted.orgpackages3587bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath".cloudflarecloudflare.cfg").write <<~EOS
      [CloudFlare]
      email = BrewTestBot@example.com
      token = 00000000000000000000000000000000
      [Work]
      token = 00000000000000000000000000000000
    EOS

    output = shell_output("#{bin}cli4 --profile Work zones 2>&1", 1)
    assert_match "cli4: zones - 6111 Invalid format for Authorization header", output
    assert_match version.to_s, shell_output("#{bin}cli4 --version 2>&1", 1)
  end
end