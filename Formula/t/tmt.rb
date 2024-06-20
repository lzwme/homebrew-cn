class Tmt < Formula
  include Language::Python::Virtualenv

  desc "Test Management Tool"
  homepage "https:tmt.readthedocs.io"
  url "https:files.pythonhosted.orgpackagesa8c406319611fe675f74fc70bd407b3d9bfd653190026991d3f47ce249a877catmt-1.34.0.tar.gz"
  sha256 "e3b8b0d0af1dd5d56522c9ebc8c6ccb4bfb04e6cf3e54f31402cf8dbc1717cc4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b887c29a83a654d9813980074df655fb34108012defce6f79c059363201219c0"
    sha256 cellar: :any,                 arm64_ventura:  "f7fad4015d76b675382e317641b23dc847370085619e4d59979f18a62487a1a9"
    sha256 cellar: :any,                 arm64_monterey: "7defc93858e3263a3ec9755478147f536a096d2d226dcae2532cb7db914ad7b3"
    sha256 cellar: :any,                 sonoma:         "ae4b5bb0170772f8e3267a2aef8ad4049cf1cd4364227570bb93a4b14e06e723"
    sha256 cellar: :any,                 ventura:        "62d7477c8ada008852642ec3e200688210d614c320721433450f8e6fc64ff645"
    sha256 cellar: :any,                 monterey:       "4cc19909f75fdb937122ff78028db39cb3664a854ea5c9a7fdcd122a207e9342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4c47737710102e789e0c26c229ce61389942d5883fae8e49fccdc05b6e0afc2"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "beakerlib"
  depends_on "certifi"
  depends_on "python@3.12"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages7d986e68cf474669042ba6ba0a7761b8be04beb8131b366d5c6b1596f8cdfec2filelock-3.15.3.tar.gz"
    sha256 "e1199bf5194a2277273dacd50269f0d87d0682088a3c561c15674ea9005d8635"
  end

  resource "fmf" do
    # No PyPI source, use git repo instead
    # https:github.comteemteefmfissues224
    url "https:github.comteemteefmfarchiverefstags1.3.0.tar.gz"
    sha256 "85f84f591d9e577742f9d3d6ee6a05f7b03ae6ee8de4c60d2083c015e61f3699"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages19f11c1dc0f6b3bf9e76f7526562d29c320fa7d6a2f35b37a1392cc0acd58263jsonschema-4.22.0.tar.gz"
    sha256 "5b22d434a45935119af990552c862e5d6d564e8f6601206b305a61fdf661a2b7"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "markupSafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pint" do
    url "https:files.pythonhosted.orgpackageseb5973fd3810d94f2c87aacc79f4e578e1d81df6f0f2800b80b7d3c4fb4e3a2dPint-0.19.2.tar.gz"
    sha256 "e1d4989ff510b378dad64f91711e7bdabe5ca78d75b06a18569ac454678c4baf"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages2daae7c404bdee1db7be09860dff423d022ffdce9269ec8e6532cce09ee7beearpds_py-0.18.1.tar.gz"
    sha256 "dc48b479d540770c811fbd1eb9ba2bb66951863e448efec2e2c102625328e92f"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}tmt init --template mini")
    assert_match "Applying template 'mini'", output
    assert_match <<~EOS, (testpath"plansexample.fmf").read
      summary: Basic smoke test
      execute:
          how: tmt
          script: tmt --help
    EOS

    assert_match version.to_s, pipe_output("#{bin}tmt --version")
  end
end