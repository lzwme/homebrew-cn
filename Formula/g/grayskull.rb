class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https:github.comcondagrayskull"
  url "https:files.pythonhosted.orgpackages75198cbf5f83ee08f5e1523b266edf0767ed3117f67cd07696621ba8dec903dagrayskull-2.7.4.tar.gz"
  sha256 "0ae16a64117669b461900b34da48917f40cbd8f868846f9aae1f5d7c0117598d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6bb8a721e140949673cd8a8ef42b5ee72bdaadd999e7f24e6039c83754449b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0440e3cd00216c97726251a5163f77e38ba7c4a2121a6d16370e6c35b4ac7362"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f2ecffc7d93a3926870d559be34e01b976061a410e20cf3083379526f4ae797"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0b6a2a757279d64306baea3d1e3529098736139be748de83f6592182a2774cb"
    sha256 cellar: :any_skip_relocation, ventura:       "77c703c3c31fec235e910f6d340f6fd767b9b5857875081cb8ff0f2dd53612c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb90753c5620591add02855597b206509540a152ffdaf07bc11c87270fb7fac"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "conda-souschef" do
    url "https:files.pythonhosted.orgpackages786ac4d067f8ef39b058a9bd03018093e97f69b7b447b4e1c8bd45439a33155dconda-souschef-2.2.3.tar.gz"
    sha256 "9bf3dba0676bc97616636b80ad4a75cd90582252d11c86ed9d3456afb939c0c3"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackagesc9a5fa2432da887652e3a0c07661ebe4aabe7f4692936c742da489178acd34depkginfo-1.12.0.tar.gz"
    sha256 "8ad91a0445a036782b9366ef8b8c2c50291f83a553478ba8580c73d3215700cf"
  end

  resource "progressbar2" do
    url "https:files.pythonhosted.orgpackages19243587e795fc590611434e4bcb9fbe0c3dddb5754ce1a20edfd86c587c0004progressbar2-4.5.0.tar.gz"
    sha256 "6662cb624886ed31eb94daf61e27583b5144ebc7383a17bae076f8f4f59088fb"
  end

  resource "python-utils" do
    url "https:files.pythonhosted.orgpackages134cef8b7b1046d65c1f18ca31e5235c7d6627ca2b3f389ab1d44a74d22f5cc9python_utils-3.9.1.tar.gz"
    sha256 "eb574b4292415eb230f094cbf50ab5ef36e3579b8f09e9f2ba74af70891449a0"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackagesa4aa25e5a20131369d82c7b8288c99c2c3011ec47a3f5953ccc9cb8145720be5rapidfuzz-3.11.0.tar.gz"
    sha256 "a53ca4d3f52f00b393fab9b5913c5bafb9afc27d030c8a1db1283da6917a860f"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-jinja2" do
    url "https:files.pythonhosted.orgpackages91e0ad199ab894f773551fc352541ce3305b9e7c366a4ae8c44ab1bc9ca3abffruamel.yaml.jinja2-0.2.7.tar.gz"
    sha256 "8449be29d9a157fa92d1648adc161d718e469f0d38a6b21e0eabb76fd5b3e663"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages416ca536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bcsemver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "stdlib-list" do
    url "https:files.pythonhosted.orgpackages5d046b37a71e92ddca16b190b7df62494ac4779d58ced4787f73584eb32c8f03stdlib_list-0.11.0.tar.gz"
    sha256 "b74a7b643a77a12637e907f3f62f0ab9f67300bce4014f6b2d3c8b4c8fd63c66"
  end

  resource "tomli-w" do
    url "https:files.pythonhosted.orgpackagesd419b65f1a088ee23e37cdea415b357843eca8b1422a7b11a9eee6e35d4ec273tomli_w-1.1.0.tar.gz"
    sha256 "49e847a3a304d516a169a601184932ef0f6b61623fe680f836a2aa7128ed0d33"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}grayskull --version").strip

    system bin"grayskull", "pypi", "grayskull"
    assert_predicate testpath"grayskullmeta.yaml", :exist?
  end
end