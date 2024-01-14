class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https:github.comzephyrproject-rtoswest"
  url "https:files.pythonhosted.orgpackagesee7a4c69c6a1054b319421d5acf028564bb1303ea9da42032a2000021d6495eewest-1.2.0.tar.gz"
  sha256 "b41e51ac90393944f9c01f7be27000d4b329615b7ed074fb0ef693b464681297"
  license "Apache-2.0"
  revision 1
  head "https:github.comzephyrproject-rtoswest.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b61bde71bb21906f6d3328813a8c9d0f3bc565c8cf6ce7c792dee17d04ca6c80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4333795dc37fdc911c215732ef62710949b36bf7e65c3cabfd5361670f08398b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fc5471f7e443b570bd1211f77a7a0ebfe87968977a09328c789f54b3d3092fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ae8f5c3a53f2e076eb9fbc5ff7170a143a26337285f81fcc5ae8bbc0c1c9933"
    sha256 cellar: :any_skip_relocation, ventura:        "dd7af72c72e47577b110f5838be4d58ea651b166c3bb293d49798244fadc1ea1"
    sha256 cellar: :any_skip_relocation, monterey:       "419a129e6a4b1e9bf023df07aa60bb6518d6e662eb677db9a1e96a86b706d555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464ab05b84d61e6d129f37b2618278483b35cd3f30c15beb96b40e0157f94a22"
  end

  depends_on "python-dateutil"
  depends_on "python-docopt"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "pykwalify" do
    url "https:files.pythonhosted.orgpackagesd5772d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages8243fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782cruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath"west" do
      mkdir "test-project"
      (testpath"westtest-projectwest.yml").write <<~EOS
        manifest:
          self:
            path: test-project
      EOS
      system bin"west", "init", "-l", testpath"westtest-project"
      assert_predicate testpath"west.west", :exist?
    end
  end
end