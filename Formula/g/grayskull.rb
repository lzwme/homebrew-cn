class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https:github.comcondagrayskull"
  url "https:files.pythonhosted.orgpackages34362af84868cd2ca7af815ec58e7ab2828e3a8b8eedc30c0b180b633bc6d94agrayskull-2.9.1.tar.gz"
  sha256 "348e3b7cf994ddfec6775d18556ddd3a39df77ddb2855f861a97330a256826b9"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "693f52b69fb1760407716e4064edd08504488784eb522520bcb8221ebaa651bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7e80dfa4f880814cee04fc4a8ba1965a04f049f8e7389d0eb2624d9ed58cb33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c81060c1c677af2853395dca5c6fa7e0e000ab6c0df02774f901d5ba519fbe55"
    sha256 cellar: :any_skip_relocation, sonoma:        "1764abca9b6669d68d38b6f0cc177c8780b48b07447c4044fe646ae67af7099b"
    sha256 cellar: :any_skip_relocation, ventura:       "e66ee842c111a50596c92ab1e69fd3f96de6dd3fe1473208694e17b0d19d6ac5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8632ef9b5fbe2e9d53743bc799a60f59e76a4d53f58c06aac1f3b15fc18704b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a29cdfa82ebcdb2ab5f025448626c0cab9715d144a21b3530ecf660a9852fa"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesd8e40c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6bbeautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
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
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackages2403e26bf3d6453b7fda5bd2b84029a426553bb373d6277ef6b5ac8863421f87pkginfo-1.12.1.2.tar.gz"
    sha256 "5cd957824ac36f140260964eba3c6be6442a8359b8c48f4adf90210f33a04b7b"
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
    url "https:files.pythonhosted.orgpackagesedf66895abc3a3d056b9698da3199b04c0e56226d530ae44a470edabf8b664f0rapidfuzz-3.13.0.tar.gz"
    sha256 "d2eaf3839e52cbcc0accbe9817a67b4b0fcf70aaeb229cfddc1c28061f9ce5d8"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages39876da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages208480203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "ruamel-yaml-jinja2" do
    url "https:files.pythonhosted.orgpackages91e0ad199ab894f773551fc352541ce3305b9e7c366a4ae8c44ab1bc9ca3abffruamel.yaml.jinja2-0.2.7.tar.gz"
    sha256 "8449be29d9a157fa92d1648adc161d718e469f0d38a6b21e0eabb76fd5b3e663"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackages3ff44a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19fsoupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "stdlib-list" do
    url "https:files.pythonhosted.orgpackages5d098d5c564931ae23bef17420a6c72618463a59222ca4291a7dd88de8a0d490stdlib_list-0.11.1.tar.gz"
    sha256 "95ebd1d73da9333bba03ccc097f5bac05e3aa03e6822a0c0290f87e1047f1857"
  end

  resource "tomli-w" do
    url "https:files.pythonhosted.orgpackages1975241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fetomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}grayskull --version").strip

    system bin"grayskull", "pypi", "grayskull"
    assert_path_exists testpath"grayskullmeta.yaml"
  end
end