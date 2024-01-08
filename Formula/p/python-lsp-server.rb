class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https:github.compython-lsppython-lsp-server"
  url "https:files.pythonhosted.orgpackagesf1cf812d3bc1fb63e32edaf291950a188d6acce9a177c59e6d7baee487dc6912python-lsp-server-1.9.0.tar.gz"
  sha256 "dc0c8298f0222fd66a52aa3170f3a5c8fe3021007a02098bb72f7fd8df353d13"
  license "MIT"
  revision 1
  head "https:github.compython-lsppython-lsp-server.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2a2d36f36df90ca3c00977a6025cf657324400eaa701bd77aad4ec3743f3d91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9a5633c792cd7f0c57ef438d15007a4804a469d823f3288e76a79650232d659"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd8452db426bde9ef97e96d540dddcbf7580900863540841f332d3fad49893f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "49c484e2bc61215ee4e1ccd8485891fc8216fed3ea764f50a73f32f52e528d2f"
    sha256 cellar: :any_skip_relocation, ventura:        "50fe0d7008e2d7d51ecbee5e4588f7aeda5dd350a36b100d15872d0737618ebb"
    sha256 cellar: :any_skip_relocation, monterey:       "52c6ee0fa903db4881ddb3374eb6907c5a8a53bb5a6bbddb70b04dc68e282678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7faab9d216d5e2709e2315965eb0d99c411708f30665ab89a01ec69e75961607"
  end

  depends_on "black"
  depends_on "mypy"
  depends_on "python@3.12"
  depends_on "ruff"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "cattrs" do
    url "https:files.pythonhosted.orgpackages1e57c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "docstring-to-markdown" do
    url "https:files.pythonhosted.orgpackages2b114be3230b6ebaeb31b2406876367243780d10a28da3a881a45a960ed4469bdocstring-to-markdown-0.13.tar.gz"
    sha256 "3025c428638ececae920d6d26054546a20335af3504a145327e657e7ad7ce1ce"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackagesd69999b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0ajedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "lsprotocol" do
    url "https:files.pythonhosted.orgpackages3efef7671a4fb28606ff1663bba60aff6af21b1e43a977c74c33db13cb83680flsprotocol-2023.0.0.tar.gz"
    sha256 "c9d92e12a3f4ed9317d3068226592860aab5357d93cf5b2451dc244eee8f35f2"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackagesa20e41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages365104defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pylsp-mypy" do
    url "https:files.pythonhosted.orgpackages769841e7fe44f2e9773bbf711ecc73c34a29b645ea6e454b36e723595d4ad4a4pylsp-mypy-0.6.8.tar.gz"
    sha256 "3f8307ca07d7e253e50e38c5fe31c371ceace0bc33d31c3429fa035d6d41bd5f"
  end

  resource "pylsp-rope" do
    url "https:files.pythonhosted.orgpackagesfe251935fc44a596427d50be237658a8fd23302a7904705422a5f1e39468e921pylsp-rope-0.1.11.tar.gz"
    sha256 "48aadf993dafa5e8fca1108b4a5431314cf80bc78cffdd56400ead9c407553be"
  end

  resource "python-lsp-black" do
    url "https:files.pythonhosted.orgpackagesc04806edc947f711fb076b564ee97bbecb5ae877816ccc0edf4347f57cd9d6b9python-lsp-black-2.0.0.tar.gz"
    sha256 "8286d2d310c566844b3c116b824ada6fccfa6ba228b1a09a0526b74c04e0805f"
  end

  resource "python-lsp-jsonrpc" do
    url "https:files.pythonhosted.orgpackages48b6fd92e2ea4635d88966bb42c20198df1a981340f07843b5e3c6694ba3557bpython-lsp-jsonrpc-1.1.2.tar.gz"
    sha256 "4688e453eef55cd952bff762c705cedefa12055c0aec17a06f595bcc002cc912"
  end

  resource "python-lsp-ruff" do
    url "https:files.pythonhosted.orgpackages77d22d1fdc5aaa6691e5264992ef723a66229a0d171d888dd6714f94accb80c6python-lsp-ruff-2.0.1.tar.gz"
    sha256 "b204b4c3016e01a69e9fd6ffbe926ba40b14bc4da57a17c755a381fe14a897d9"

    # this depends on `ruff` solely to install the binary,
    # but we can just depend on the `ruff` formula in Homebrew
    patch :DATA
  end

  resource "pytoolconfig" do
    url "https:files.pythonhosted.orgpackages78ab9e5168b7101e682e2916b5d028e9fcd857b79cbbc9a29e36b1597f3926d0pytoolconfig-1.2.6.tar.gz"
    sha256 "f2d00ea4f8cbdffd3006780ba51016618c835b338f634e3f7f8b2715b1710889"
  end

  resource "rope" do
    url "https:files.pythonhosted.orgpackages5338b28a6eeaf083dcdc1c779edda80d399283fb87008fffb4a556bc3be634e2rope-1.11.0.tar.gz"
    sha256 "ac0cbdcda5a546e1e56c54976df07ea2cb04c806f65459bc213536c5d1bc073e"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackagesc03fd7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "ujson" do
    url "https:files.pythonhosted.orgpackages6e546f2bdac7117e89a47de4511c9f01732a283457ab1bf856e1e51aa861619eujson-5.9.0.tar.gz"
    sha256 "89cc92e73d5501b8a7f48575eeb14ad27156ad092c2e9fc7e3cf949f07e75532"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages2e627a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[black mypy].map do |package_name|
      package = Formula[package_name].opt_libexec
      packagesite_packages
    end
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}pylsp -v 2>&1", input)
    assert_match(^Content-Length: \d+i, output)

    expected_plugins = %w[
      black
      pylsp_mypy
      pylsp_rope
      ruff
    ]
    expected_plugins.each do |plugin_name|
      assert_match("Loaded pylsp plugin #{plugin_name}", output)
    end
  end
end

__END__
diff --git apyproject.toml bpyproject.toml
index cfdf720..d84c1b7 100644
--- apyproject.toml
+++ bpyproject.toml
@@ -13,7 +13,6 @@ readme = "README.md"
 requires-python = ">=3.7"
 license = {text = "MIT"}
 dependencies = [
-  "ruff>=0.1.5, <0.2.0",
   "python-lsp-server",
	 "cattrs!=23.2.1",
   "lsprotocol>=2022.0.0a1",