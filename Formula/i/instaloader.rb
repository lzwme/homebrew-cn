class Instaloader < Formula
  include Language::Python::Virtualenv

  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/7e/35/1f8d36c0656d4797fc5089c016995447f2b439e8fb9df02bf9d7873566fc/instaloader-4.11.tar.gz"
  sha256 "7478a1f0ed5c05911832c50cb19747243a461b5d434907f9fdb7d2d750d1b4f5"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08c103c7e609770f6ca32650894cc27376ad307fe49f629ad4e6bb3dcdbd5fcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08c103c7e609770f6ca32650894cc27376ad307fe49f629ad4e6bb3dcdbd5fcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08c103c7e609770f6ca32650894cc27376ad307fe49f629ad4e6bb3dcdbd5fcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "08c103c7e609770f6ca32650894cc27376ad307fe49f629ad4e6bb3dcdbd5fcf"
    sha256 cellar: :any_skip_relocation, ventura:        "08c103c7e609770f6ca32650894cc27376ad307fe49f629ad4e6bb3dcdbd5fcf"
    sha256 cellar: :any_skip_relocation, monterey:       "08c103c7e609770f6ca32650894cc27376ad307fe49f629ad4e6bb3dcdbd5fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "814fd3bf9a42c39d09dab1f6d5924d0a6604bb8fa82061e054120df3a79d998e"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/instaloader --login foo --password bar 2>&1", 1)
    assert_match "Fatal error: Login error:", output

    assert_match version.to_s, shell_output("#{bin}/instaloader --version")
  end
end