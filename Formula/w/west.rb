class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https:github.comzephyrproject-rtoswest"
  url "https:files.pythonhosted.orgpackagesd1aa288fc09dee13631538ad040d1b8e09f78594cdf3b53ff869c283d245bf20west-1.3.0.tar.gz"
  sha256 "89320034be87099d16e75f4760ac0d1ed67e8978928e468ab993e3fba0cfe92f"
  license "Apache-2.0"
  revision 1
  head "https:github.comzephyrproject-rtoswest.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97bf98cb70cd8be9ca4d901b9249a8f367dd0e59fd0e668dcc26ea2278132cc2"
    sha256 cellar: :any,                 arm64_sonoma:  "1734f07dc4733422aca5324c07b234595fb0a53c5e97b96d286e494e87cd0ce7"
    sha256 cellar: :any,                 arm64_ventura: "43b240bd56f80e5ee9225c4de04dc9530000a1ac57bb409622b1cd05baff5c65"
    sha256 cellar: :any,                 sonoma:        "a20b55ddc1f78a162f2e74b7189dc129167ad347663b2339b838c86a3141b825"
    sha256 cellar: :any,                 ventura:       "523c12554f615e44ec471c5c92620bc4c0ded42266b16c871480f1bd57875491"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c8dcc364cc4381b8f7b6db703c166f413a19a6f931d8d48eddaed97c1603360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cafa7c4ca412312cbe93dad350921ab416304de2eaf48467ed0d1329f4d9e6d"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pykwalify" do
    url "https:files.pythonhosted.orgpackagesd5772d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackagesea46f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages9e8bdc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath"west" do
      mkdir "test-project"
      (testpath"westtest-projectwest.yml").write <<~YAML
        manifest:
          self:
            path: test-project
      YAML
      system bin"west", "init", "-l", testpath"westtest-project"
      assert_path_exists testpath"west.west"
    end
  end
end