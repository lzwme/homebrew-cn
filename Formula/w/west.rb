class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https:github.comzephyrproject-rtoswest"
  url "https:files.pythonhosted.orgpackagesee7a4c69c6a1054b319421d5acf028564bb1303ea9da42032a2000021d6495eewest-1.2.0.tar.gz"
  sha256 "b41e51ac90393944f9c01f7be27000d4b329615b7ed074fb0ef693b464681297"
  license "Apache-2.0"
  head "https:github.comzephyrproject-rtoswest.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bb870bcf5e5040b99e408305cf691efc0f386d46ca6d85d857ad25232583e53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16b56dc1ae2605b70b85c80dee664bda576a0becc9d31ed54b5eaf1a8396541d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a86c4f1654c564b51d6980c8dfa071cd5a90564741722b01511a5522ee4b107"
    sha256 cellar: :any_skip_relocation, sonoma:         "b963549faf1b5450da940d8ca35cf62114b9fddc79023f92a745a00354012642"
    sha256 cellar: :any_skip_relocation, ventura:        "50aab5b051ae5a8ce493138b6cd09bf03f8a8cedf628d1426bba396e16030895"
    sha256 cellar: :any_skip_relocation, monterey:       "6003cede937db2cad7b51e8fbc31613771d66214091c14808880a280feb70c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c13b6ef898a83b0a4434bc8b396e4f0621cb8794b0e807f952d811bef7d8a3"
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
    url "https:files.pythonhosted.orgpackagesde7d4f70a93fb0bdc3fb2e1cbd859702d70021ab6962b7d07bd854ac3313cb54ruamel.yaml-0.17.35.tar.gz"
    sha256 "801046a9caacb1b43acc118969b49b96b65e8847f29029563b29ac61d02db61b"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
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