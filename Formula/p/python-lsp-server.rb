class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https:github.compython-lsppython-lsp-server"
  url "https:files.pythonhosted.orgpackages60fc1779454d6fb22dcda94c2b892bdc40cfd448007a68ee57935b491891707bpython-lsp-server-1.10.1.tar.gz"
  sha256 "ec4c5706af67a265a19173fe4beb3b0a2c1626fa33a15ea952c2f288798b8c0d"
  license "MIT"
  head "https:github.compython-lsppython-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ee848e6ddf094b7e47556b8c0998b6370dcf1b2e3548cb78db72f757f33ce41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7039baffbf09d67591f77538988bdb41f3e7958af14f72c5378859052a7b21b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff845cff1809afc73f4c69a96384dcaec0ab63b5064a84e0bf8d5d18b02fdaf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b08183d49c72dea383918df5e40389485112c697ca6a362f8d74aaaffce16c4"
    sha256 cellar: :any_skip_relocation, ventura:        "ce680beb206ef83b6f7b7ca458170f4b1115e68e2c0d442e208f60a2be113c8d"
    sha256 cellar: :any_skip_relocation, monterey:       "d12e0d89a46ea135b1641330fd7441d59d64bcfb34bc03a469a20ec77ed08f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "073ecd72282667dd95c119a2c678172d882142779da48019af40c4357bae850d"
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
    url "https:files.pythonhosted.orgpackages7aad6a66abd14676619bd56f6b924c96321a2e2d7d86558841d94a30023eec53docstring-to-markdown-0.15.tar.gz"
    sha256 "e146114d9c50c181b1d25505054a8d0f7a476837f0da2c19f07e06eaed52b73d"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackagesd69999b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0ajedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "lsprotocol" do
    url "https:files.pythonhosted.orgpackages9df66e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6flsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackagesa20e41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages54c643f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "pylsp-mypy" do
    url "https:files.pythonhosted.orgpackages769841e7fe44f2e9773bbf711ecc73c34a29b645ea6e454b36e723595d4ad4a4pylsp-mypy-0.6.8.tar.gz"
    sha256 "3f8307ca07d7e253e50e38c5fe31c371ceace0bc33d31c3429fa035d6d41bd5f"
  end

  resource "pylsp-rope" do
    url "https:files.pythonhosted.orgpackagesfec665994dd6c47fa420ba9e4d185da503ef0e654770c3f21de756b39db7cd96pylsp-rope-0.1.15.tar.gz"
    sha256 "d1fd16cc971539f1f569b267bd908b339fd6d497d5c520c01fe67500303a9144"
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
    url "https:files.pythonhosted.orgpackagesae8e623702d362010dee2c45799242d5b42a54489552458ee5a4ad394632ecdapython-lsp-ruff-2.2.0.tar.gz"
    sha256 "67c14067f76bc3d16bd5473a574e0d7b3bd422d723b62d2b2a83356e8af051db"

    # this depends on `ruff` solely to install the binary,
    # but we can just depend on the `ruff` formula in Homebrew
    patch :DATA
  end

  resource "pytoolconfig" do
    url "https:files.pythonhosted.orgpackages18dcabf70d2c2bcac20e8c71a7cdf6d44e4ddba4edf65acb179248d554d743dbpytoolconfig-1.3.1.tar.gz"
    sha256 "51e6bd1a6f108238ae6aab6a65e5eed5e75d456be1c2bf29b04e5c1e7d7adbae"
  end

  resource "rope" do
    url "https:files.pythonhosted.orgpackages4cc5606e9b76ce5f0fe1b66db493b13e4dc6a9d495570d30fc8ea76d275693d9rope-1.12.0.tar.gz"
    sha256 "93a1bb991fbf0426e8d415102d1c092ccc42e826ce9a42c4d61ce53d7786d9d9"
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
index 5eb87bf..5bdc9e4 100644
--- apyproject.toml
+++ bpyproject.toml
@@ -13,7 +13,6 @@ readme = "README.md"
 requires-python = ">=3.8"
 license = {text = "MIT"}
 dependencies = [
-  "ruff>=0.2.0",
   "python-lsp-server",
 	"cattrs!=23.2.1",
   "lsprotocol>=2023.0.1",