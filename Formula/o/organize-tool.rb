class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https:github.comtfeldmannorganize"
  url "https:files.pythonhosted.orgpackages24af3ad46df41f247aff4c9e1d9a3cd1bb65d9b9db7ae40322681189561d96c4organize_tool-3.0.0.tar.gz"
  sha256 "13791171a4621a18c37aaade75805f9de643fc646596cf6c7a4cb399bd1d9e54"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3ab34274005b6f1d3cd2e0b1b4c6a8c919e0acc304dd5983b7d499c1197667a"
    sha256 cellar: :any,                 arm64_ventura:  "bfc9d77dac8dbc7d0aa59e46a0e968d48a5e98e5b634cd1f46d43f9c81ab669d"
    sha256 cellar: :any,                 arm64_monterey: "439a89e76d451338cd6621732c0321ab826c56919e2f6fb9e1f980e773f762ca"
    sha256 cellar: :any,                 sonoma:         "72751dc27f50dcb7f08da6287abf932abf10009a3a8061be665f55a5171beac1"
    sha256 cellar: :any,                 ventura:        "f59ef24c2f152ee2eac2e7b8c4e3ba74d8c0b6a33c4c67da11b01e3663d6fe1a"
    sha256 cellar: :any,                 monterey:       "0874d3649e85cdf9d057fc38fa048e971e4892d68cded0fe828c4b136ea7d46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e96485ed6440b4f34b15f106e9aa13337190a089ffcf52aca20e20fcb927cd2"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build # for pydantic_core
  depends_on "freetype"
  depends_on "openjpeg"
  depends_on "pygments"
  depends_on "python-click"
  depends_on "python-jinja"
  depends_on "python-markupsafe"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "docopt-ng" do
    url "https:files.pythonhosted.orgpackagese4508d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "exifread" do
    url "https:files.pythonhosted.orgpackages5fa6e5bdca841e5cc1a0eb7b9bf64854a4bf4e19e6de1a14092f93b8c907e87aExifRead-2.3.2.tar.gz"
    sha256 "a0f74af5040168d3883bbc980efe26d06c89f026dc86ba28eb34107662d51766"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages62d17feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9aplatformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesaa3f56142232152145ecbee663d70a19a45d078180633321efb3847d2562b490pydantic-2.5.3.tar.gz"
    sha256 "b3ef57c62535b0941697cce638c08900d87fcb67e29cfa99e8a68f747f393f7a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesb27d8304d8471cfe4288f95a3065ebda56f9790d087edc356ad5bd83c89e2d79pydantic_core-2.14.6.tar.gz"
    sha256 "1fd0c1d395372843fba13a51c28e3bb9d59bd7aebfeb17358ffaaa1e4dbbe948"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "send2trash" do
    url "https:files.pythonhosted.orgpackages4ad2d4b4d8b1564752b4e593c6d007426172b6574df5a7c07322feba010f5551Send2Trash-1.8.2.tar.gz"
    sha256 "c132d59fa44b9ca2b1699af5c86f57ce9f4c5eb56629d5d55fbb7a35f84e2312"
  end

  resource "simplematch" do
    url "https:files.pythonhosted.orgpackagesd4c5209aa49f6c366f5b1d80e9eef2f75270079df3c9dec4658e0716e4bcd6absimplematch-1.4.tar.gz"
    sha256 "55a77278b3d0686cb38e3ffe5a326a5f59c2995f1ba1fa1a4f68872c17caf4cb"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages1b2df189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6ftypes-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages0c1deb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    dependencies = resources.to_set(&:name)
    if OS.linux?
      # `macos-tags` and its dependencies are only needed on macOS
      # TODO: Currently requires manual check to confirm PyPI dependency tree
      dependencies -= %w[macos-tags mdfind-wrapper xattr cffi pycparser]
      # Same for `pyobjc-framework-cocoa` and its dependencies
      dependencies -= %w[pyobjc-framework-cocoa pyobjc-core]
    end
    dependencies.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath
  end

  test do
    config_file = testpath"config.yaml"
    config_file.write <<~EOS
      rules:
        - locations: #{testpath}
          filters:
            - extension: txt
          actions:
            - echo: 'Found: {path.name}'
            - delete
    EOS

    touch testpath"homebrew.txt"

    assert_match "Found: homebrew.txt", shell_output("#{bin}organize sim #{config_file}")
    system bin"organize", "run", config_file
    refute_predicate testpath"homebrew.txt", :exist?
  end
end