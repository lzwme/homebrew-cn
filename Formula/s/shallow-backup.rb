class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https:github.comalichtmanshallow-backup"
  url "https:files.pythonhosted.orgpackagesd056427960ea933c35b43b561d8f1379d4f7794b67f785ec3137adaf6ce5073eshallow_backup-6.4.tar.gz"
  sha256 "b933d19d7238d04eb1bf3943078ee74933dbe6faf2d5b503a865242d0d6bd2e6"
  license "MIT"
  head "https:github.comalichtmanshallow-backup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1c76ca95ae2f0ee6aadb070738694c2421f5d5e52ca7de63fd62be21144606b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "748a268c62f0221e361dd60fca3552f0b056e34e8c0b6ff04db6675d9eadeef9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "748a268c62f0221e361dd60fca3552f0b056e34e8c0b6ff04db6675d9eadeef9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "748a268c62f0221e361dd60fca3552f0b056e34e8c0b6ff04db6675d9eadeef9"
    sha256 cellar: :any_skip_relocation, sonoma:         "80f3c1dcae355fd3e19bc023ec177a74aa2e1c9631d73605affb03c1b50f8a4d"
    sha256 cellar: :any_skip_relocation, ventura:        "80f3c1dcae355fd3e19bc023ec177a74aa2e1c9631d73605affb03c1b50f8a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "0f2be7fca0fbda026b9cadf80a98e0237fc9b0c6b55727fd962688602da56258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10d2d80881f1108e246673e7c0ffcbfee4a10ea5d80ec8b71a558c6ba217ec6d"
  end

  depends_on "python@3.12"

  resource "blessed" do
    url "https:files.pythonhosted.orgpackages25ae92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "editor" do
    url "https:files.pythonhosted.orgpackages2a92734a4ab345914259cb6146fd36512608ea42be16195375c379046f33283deditor-1.6.6.tar.gz"
    sha256 "bb6989e872638cd119db9a4fce284cd8e13c553886a1c044c6b8d8a160c871f8"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesb6a1106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "inquirer" do
    url "https:files.pythonhosted.orgpackagesf233d495a92c48203f33d2f4556a0a662dab1bd511a7458910c866f1d7a6a1a3inquirer-3.3.0.tar.gz"
    sha256 "2722cec4460b289aab21fc35a3b03c932780ff4e8004163955a8215e20cfd35e"
  end

  resource "readchar" do
    url "https:files.pythonhosted.orgpackages2385a83385c8765af35c3fdd9cf67a387107b99bc545b8559e1f097c9d777ddereadchar-4.1.0.tar.gz"
    sha256 "6f44d1b5f0fd93bd93236eac7da39609f15df647ab9cea39f5bc7478b3344b99"
  end

  resource "runs" do
    url "https:files.pythonhosted.orgpackages266db9aace390f62db5d7d2c77eafce3d42774f27f1829d24fa9b6f598b3ef71runs-1.2.2.tar.gz"
    sha256 "9dc1815e2895cfb3a48317b173b9f1eac9ba5549b36a847b5cc60c3bf82ecef1"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "xmod" do
    url "https:files.pythonhosted.orgpackages72b2e3edc608823348e628a919e1d7129e641997afadd946febdd704aecc5881xmod-1.8.1.tar.gz"
    sha256 "38c76486b9d672c546d57d8035df0beb7f4a9b088bc3fb2de5431ae821444377"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(
      bin"shallow-backup",
      shells:                 [:fish, :zsh],
      shell_parameter_format: :click,
    )
  end

  test do
    # Creates a config file and adds a test file to it
    # There is colour in stdout, hence there are ANSI escape codes
    test_config = testpath".configshallow-backup.json"
    assert_equal "\e[34m\e[1mCreating config file at: \e[22m#{test_config}\e[0m\n" \
                 "\e[34m\e[1mAdded: \e[22m#{test_fixtures("test.svg")}\e[0m",
    shell_output("#{bin}shallow-backup --add-dot #{test_fixtures("test.svg")}").strip

    assert_match version.to_s, shell_output("#{bin}shallow-backup --version")
  end
end