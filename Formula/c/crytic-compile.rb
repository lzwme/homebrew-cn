class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https:github.comcryticcrytic-compile"
  url "https:files.pythonhosted.orgpackages7607b629a6bf2c56f63bb6cd1b2000e58395642dcd72ebae746282a58c0feb3fcrytic-compile-0.3.6.tar.gz"
  sha256 "9a53c8913daadfd0f67e288acbe9e74130fe52cc344849925e6e969abc1b8340"
  license "AGPL-3.0-only"
  head "https:github.comcryticcrytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc3cf0ba655eb1f0521d62286417f3d814c90fd02ca03f5f1b5ac68eee3c7a0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82e82b993a3611d312efbd1b3a065ad17ba9bb670a7fd7508c408224bc9ac399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14951768c72ea041f9be3a3ef75692dad71d532a3ab22390adbda71803535a69"
    sha256 cellar: :any_skip_relocation, sonoma:         "60e53e28ee701c6c76ee520671290b5a4b1bbaa77b70b54b0e6ac0c36a867dd6"
    sha256 cellar: :any_skip_relocation, ventura:        "75fe965fab693af754eaed095f04b20136faa76f5f39bfb7b62731f5d19a9d11"
    sha256 cellar: :any_skip_relocation, monterey:       "8e66bf16fb65fd13a58a928bbe0f8bd0f5d257c8745b4ae7406a25ec551f323e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "110c0b2d3ea9ab8f3c44b953cd1cfeb588e9a6ccab6dd6d9a98a0f7979bb9e1c"
  end

  depends_on "python-setuptools"
  depends_on "python-toml"
  depends_on "python@3.12"
  depends_on "solc-select"

  resource "cbor2" do
    url "https:files.pythonhosted.orgpackagesbb66b09bf8421645852616044d3de9e632e1131c059f928a53bf46b1bc08e3eccbor2-5.6.0.tar.gz"
    sha256 "9d94e2226f8f5792fdba5ab20e07b9bfe02e76c10c3ca126418cd4310439d002"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages("python3.12")
    solc_select = Formula["solc-select"].opt_libexec
    (libexecsite_packages"homebrew-solc-select.pth").write solc_selectsite_packages
  end

  test do
    resource "testdata" do
      url "https:github.comcryticslitherrawd0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4testsast-parsingcompilevariable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      system bin"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip",
             "--export-format=solc", "--export-dir=#{testpath}export"
    end

    assert_predicate testpath"exportcombined_solc.json", :exist?
  end
end