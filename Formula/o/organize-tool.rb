class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https://github.com/tfeldmann/organize"
  url "https://files.pythonhosted.org/packages/b7/f2/99a8dae09e1f597e7d134fbe8355c8456a9c08528cee00151b855157b1a9/organize_tool-2.4.3.tar.gz"
  sha256 "4e82593b88bacc3a3103df567737d57891adbbeaf9f654af4c2be8c1cf755e11"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3f9d0e6eb6c00e7fd86df3e41b5ccdb073c8a6416dfe4e988d10670983700d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "438f4a1cb5e6a95e6325200fa80f68ce83a1751d7f2db637338fdaec2ab92ba0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dee85bb647f2c958631da615b12cffbe4e3df600f56d61f812d23909532df1da"
    sha256 cellar: :any_skip_relocation, sonoma:         "dee15155602c02c95edd91eaacdf6304830fdbe81fae1ad7616b6a1bf75f369b"
    sha256 cellar: :any_skip_relocation, ventura:        "8083f6621c5beec389d359ab7d2221eb457041b3585c37b9337326ecb5292e6f"
    sha256 cellar: :any_skip_relocation, monterey:       "395918e5847883a7709fc7665a6325e70d0635d8c8574ba80ee2390461e1f741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "395f2b8a3b92488f60c8fd091714d7255bfa4ecd5ddc4e7fa358621476e46a78"
  end

  depends_on "cmake" => :build
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

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "exifread" do
    url "https://files.pythonhosted.org/packages/5f/a6/e5bdca841e5cc1a0eb7b9bf64854a4bf4e19e6de1a14092f93b8c907e87a/ExifRead-2.3.2.tar.gz"
    sha256 "a0f74af5040168d3883bbc980efe26d06c89f026dc86ba28eb34107662d51766"
  end

  resource "fs" do
    url "https://files.pythonhosted.org/packages/5d/a9/af5bfd5a92592c16cdae5c04f68187a309be8a146b528eac3c6e30edbad2/fs-2.4.16.tar.gz"
    sha256 "ae97c7d51213f4b70b6a958292530289090de3a7e15841e108fbe144f069d313"
  end

  resource "macos-tags" do
    url "https://files.pythonhosted.org/packages/d4/6e/e0b2ea37ef831a5c6b5aebbd14701d96d9dc061f04a867b05335a4bc099d/macos-tags-1.5.1.tar.gz"
    sha256 "f144c5bc05d01573966d8aca2483cb345b20b76a5b32e9967786e086a38712e7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdfind-wrapper" do
    url "https://files.pythonhosted.org/packages/0e/74/148968c2665c0f2db1fbd470fbb454b1f808ea5d4cb8d75bc99f451d0ece/mdfind-wrapper-0.1.5.tar.gz"
    sha256 "c0dbd5bc99c6d1fb4678bfa1841a3380ccac61e9b43a26a8d658aa9cafe27441"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/a4/ca/9f5f8aab90b7b9d006ee40e08dcfa1a5f74ab10b4504951bca97379016aa/pyobjc-core-10.0.tar.gz"
    sha256 "3dd0a7b3acd7e0b8ffd3f5331b29a3aaebe79a03323e61efeece38627a6020b3"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/50/86/afa561caab8883b2ce155fd0067f6265bf10780a4db08bff3d76714c1dc4/pyobjc-framework-Cocoa-10.0.tar.gz"
    sha256 "723421eff4f59e4ca9a9bb8ec6dafbc0f778141236fa85a49fdd86732d58a74c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/4a/d2/d4b4d8b1564752b4e593c6d007426172b6574df5a7c07322feba010f5551/Send2Trash-1.8.2.tar.gz"
    sha256 "c132d59fa44b9ca2b1699af5c86f57ce9f4c5eb56629d5d55fbb7a35f84e2312"
  end

  resource "simplematch" do
    url "https://files.pythonhosted.org/packages/d4/c5/209aa49f6c366f5b1d80e9eef2f75270079df3c9dec4658e0716e4bcd6ab/simplematch-1.4.tar.gz"
    sha256 "55a77278b3d0686cb38e3ffe5a326a5f59c2995f1ba1fa1a4f68872c17caf4cb"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/91/ac/5898d1811abc88c3710317243168feff61ce12be220b9c92ee045ecd66c4/xattr-0.9.9.tar.gz"
    sha256 "09cb7e1efb3aa1b4991d6be4eb25b73dc518b4fe894f0915f5b0dcede972f346"
  end

  # upstream issue report, https://github.com/tfeldmann/organize/issues/327
  # upstream PR ref, https://github.com/tfeldmann/organize/pull/328
  patch :DATA

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
    config_file = testpath/"config.yaml"
    config_file.write <<~EOS
      rules:
        - locations: #{testpath}
          filters:
            - extension: txt
          actions:
            - echo: 'Found: {path.name}'
            - delete
    EOS

    touch testpath/"homebrew.txt"

    assert_match "Found: homebrew.txt", shell_output("#{bin}/organize sim #{config_file}")
    system bin/"organize", "run", config_file
    refute_predicate testpath/"homebrew.txt", :exist?
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index cabf427..1027920 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -31,7 +31,7 @@ classifiers = [
 organize = "organize.cli:cli"

 [tool.poetry.dependencies]
-python = ">=3.8,<3.12"
+python = ">=3.8,<3.13"
 fs = ">=2.4.16"
 rich = "^13.4.2"
 PyYAML = "^6.0"