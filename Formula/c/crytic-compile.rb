class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https:github.comcryticcrytic-compile"
  url "https:files.pythonhosted.orgpackagese732dfacd10aedde8576594566c53de75904b4d99abbf5e256ac6de8d3baae18crytic_compile-0.3.8.tar.gz"
  sha256 "dd8841701cfabf132ffff8b59e8dac32f5fafe369ec8b14b855f2f70565f11ad"
  license "AGPL-3.0-only"
  head "https:github.comcryticcrytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7fb34f6bee0ab4a899f1b3bbec182ca72e2e30fef9bfec69c2636bccd1bffbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272d2f3f209dc65a1a165e7f6fcf619d16b4bbf278a3a0d34252c37291b4e3d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de1c70a68e51a86b97959b63089f7853ccf8f6ca55630241af891919d556d55d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dad1e8401b47e4129542bdcb407086a4184cdf77845acb50be85b2767a9387d"
    sha256 cellar: :any_skip_relocation, ventura:       "31f5a9231ab385be2527f803c4d5c82cafffb9f944be33419d248c124da971ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18ab49e38d170a2c6bf2bcbc5864c211dccf6697f8c94b15e5ee21d7ecd41564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf608d327b581dc8ffd158e6877fbbc9ce2be31b1e206861011408ba04953a4"
  end

  depends_on "python@3.13"

  resource "cbor2" do
    url "https:files.pythonhosted.orgpackagese4aaba55b47d51d27911981a18743b4d3cebfabccbb0598c09801b734cec4184cbor2-5.6.5.tar.gz"
    sha256 "b682820677ee1dbba45f7da11898d2720f92e06be36acec290867d5ebf3d7e09"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages135213b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "solc-select" do
    url "https:files.pythonhosted.orgpackages60a02a2bfbbab1d9bd4e1a24e3604c30b5d6f84219238f3c98f06191faf5d019solc-select-1.0.4.tar.gz"
    sha256 "db7b9de009af6de3a5416b80bbe5b6d636bf314703c016319b8c1231e248a6c7"
  end

  def install
    virtualenv_install_with_resources
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

    assert_path_exists testpath"exportcombined_solc.json"
  end
end