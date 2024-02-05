class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https:github.comtfeldmannorganize"
  url "https:files.pythonhosted.orgpackages95bc485c1ec8666496ce96ec17bb0158c299709b323b6c22e9ae6de18fdca2a9organize_tool-3.1.0.tar.gz"
  sha256 "16012c34abdd39ee16ca0baa19dd97b5cb172951b697b806c6ec3d7a0d429c93"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "190ca63285fdee909eaf20baa98f81bc2fa712892353eff91800c0a9d9ea9db9"
    sha256 cellar: :any,                 arm64_ventura:  "74a1db448c45b7e803126a6e50ea9ff5b3e9aa1cae47bf76a2d90cd9d922160a"
    sha256 cellar: :any,                 arm64_monterey: "38d6c8bfed09dfd0d9aae806800c7fc4aa726b4db04a5fdb9731df286776227d"
    sha256 cellar: :any,                 sonoma:         "4544ecdc5996f1de4f3e596f6c66932beee819396d80427be1df8573c3ffa075"
    sha256 cellar: :any,                 ventura:        "379cb9504cee5c19782eb7f48713d18e0c29788c141c084effa6bdcbcd764417"
    sha256 cellar: :any,                 monterey:       "fdb215b192fbbbdf49927c4796e49bf43318fcf6949a3b5a82c141a75725e782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c95c0186918b375365906474159f3a10fc9c17218a0e63c3e06a56cec3ab105e"
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
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages786c87e7c6e46206e27b3037acdf637906c4be500a0b1dd7ccbb805a72b9f494pydantic-2.6.0.tar.gz"
    sha256 "ae887bd94eb404b09d86e4d12f93893bdca79d766e738528c6fa1c849f3c6bcf"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesa0a761d013c73773bb03d02de9de8e4e5b2ed2c100dc98ae7046d54485ecf5d4pydantic_core-2.16.1.tar.gz"
    sha256 "daff04257b49ab7f4b3f73f98283d3dbb1a65bf3500d55c7beac3c66c310fe34"
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
    url "https:files.pythonhosted.orgpackages9b472a9e51ae8cf48cea0089ff6d9d13fff60701f8c9bf72adaee0c4e5dc88f9types-python-dateutil-2.8.19.20240106.tar.gz"
    sha256 "1f8db221c3b98e6ca02ea83a58371b22c374f42ae5bbdf186db9c9a76581459f"
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