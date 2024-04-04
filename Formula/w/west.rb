class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https:github.comzephyrproject-rtoswest"
  url "https:files.pythonhosted.orgpackagesee7a4c69c6a1054b319421d5acf028564bb1303ea9da42032a2000021d6495eewest-1.2.0.tar.gz"
  sha256 "b41e51ac90393944f9c01f7be27000d4b329615b7ed074fb0ef693b464681297"
  license "Apache-2.0"
  revision 2
  head "https:github.comzephyrproject-rtoswest.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "26576af9f46307f4848f693b8735d4db5034db58937e82422e9ea716e49b0833"
    sha256 cellar: :any,                 arm64_ventura:  "eaaf79d5b5ea31abcc74489f1624ee88a8deb35d819899a67457166a15ec0dd2"
    sha256 cellar: :any,                 arm64_monterey: "8411289dc521b14e6444ab4e60ca9b44eaa62982e7c9652aa4d379b96cfa0ba9"
    sha256 cellar: :any,                 sonoma:         "8e725d4997ab94daf01a382e332f14ebdb86ea3cabad292183b9ec24a35cc4db"
    sha256 cellar: :any,                 ventura:        "a74d001bc69b95a6c877480d11ff48bb318819fad6b1f7ddc0197ccee8153052"
    sha256 cellar: :any,                 monterey:       "d3b81aa7b72db48dc467ab2b2081b7c0a21058200dbc43ab07e3059bba1eb371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0efc8af2f61986d8008c990bdc936fd8a03c3386f1b9b32df70ba371fafc3e4a"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pykwalify" do
    url "https:files.pythonhosted.orgpackagesd5772d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc93d74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fadsetuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

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