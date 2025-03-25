class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https:github.comddelangepipgrip"
  url "https:files.pythonhosted.orgpackages408ea3d17fcdab26b738c6067142461d721c03da8e627944b184bfb28ec8ae3bpipgrip-0.10.14.tar.gz"
  sha256 "f99791cbe4819f4477237b3487bc8f69258236058f3093c5ccdfd9b157405308"
  license "BSD-3-Clause"
  head "https:github.comddelangepipgrip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8200545764bb23a787a49b0fc005dde71dcf392ea6768e4b35882928be00c753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8200545764bb23a787a49b0fc005dde71dcf392ea6768e4b35882928be00c753"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8200545764bb23a787a49b0fc005dde71dcf392ea6768e4b35882928be00c753"
    sha256 cellar: :any_skip_relocation, sonoma:        "6765b9fc84ef8911ea27ca8b1d4585cda50a6c582ac32bce062e7fe5a813d2ea"
    sha256 cellar: :any_skip_relocation, ventura:       "6765b9fc84ef8911ea27ca8b1d4585cda50a6c582ac32bce062e7fe5a813d2ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9845a02f039857039cd822de651efab04a91e70fe02cc07699a8dacbb0cdcdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ccdc85fb3e71bcbd61b7c62fe7f213f8cdc11461b440792c881a155ab03e582"
  end

  depends_on "python@3.13"

  resource "anytree" do
    url "https:files.pythonhosted.orgpackagesf9442dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7deaanytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"

    # poetry build patch, upstream pr ref, https:github.comc0fec0deanytreepull271
    patch do
      url "https:github.comc0fec0deanytreecommitaa20d31631403f9650f3b4090d5c8579f9abaf5b.patch?full_index=1"
      sha256 "05b9b5ecf80986fcecb195d798e1277c9e7c69ed5fd44fea9898e20a44828587"
    end
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackages8a982d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25cwheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"pipgrip", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}pipgrip dxpy --no-cache-dir")
  end
end