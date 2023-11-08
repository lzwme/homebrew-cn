class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/f1/cf/812d3bc1fb63e32edaf291950a188d6acce9a177c59e6d7baee487dc6912/python-lsp-server-1.9.0.tar.gz"
  sha256 "dc0c8298f0222fd66a52aa3170f3a5c8fe3021007a02098bb72f7fd8df353d13"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae89db9953d04a4b562642d2ee7caa9a346515aad3c3150253763ba278aa4a4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "847e5b525ac3045a16785fe293267e9f8c0a42425aa3ae019df22dc2bf5bb2af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56c8f2a050c9f0de4c520e7cad7f18762089823802698415f88781e20c95d66"
    sha256 cellar: :any_skip_relocation, sonoma:         "71fd8b74ec122ce42d4a4e4852e903ceb9dca53a3aaf18650253273f2b700dfb"
    sha256 cellar: :any_skip_relocation, ventura:        "566ddadebd3c3ddc9d53d0965c6b1e24306d7a9987684733f92732b6435c9905"
    sha256 cellar: :any_skip_relocation, monterey:       "d9f25971ff0a9bae836d479c45c043b621d1336aed3bd7ae63dd8a95a43497a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656eeca5d105639d5f9a0586797d23ceda1f99595deccffbec3f15b7e6f3e6b7"
  end

  depends_on "black"
  depends_on "mypy"
  depends_on "pydocstyle"
  depends_on "python@3.11"
  depends_on "ruff"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/68/d4/27f9fd840e74d51b6d6a024d39ff495b56ffde71d28eb82758b7b85d0617/cattrs-23.1.2.tar.gz"
    sha256 "db1c821b8c537382b2c7c66678c3790091ca0275ac486c76f3c8f3920e83c657"
  end

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/2b/11/4be3230b6ebaeb31b2406876367243780d10a28da3a881a45a960ed4469b/docstring-to-markdown-0.13.tar.gz"
    sha256 "3025c428638ececae920d6d26054546a20335af3504a145327e657e7ad7ce1ce"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/d6/99/99b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0a/jedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/22/a1/4df53bbe3663de65ad90c6bbc2e6e8779b61fba1e13ee9a21a0f2f7db8f9/lsprotocol-2023.0.0b1.tar.gz"
    sha256 "f7a2d4655cbd5639f373ddd1789807450c543341fa0a32b064ad30dbb9f510d4"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pylsp-mypy" do
    url "https://files.pythonhosted.org/packages/5f/56/5dd31793481169f71f3849d9b455c253511c1298db7ec73f484b923bac22/pylsp-mypy-0.6.7.tar.gz"
    sha256 "06ba6d09bdd6ec29025ccc952dd66a849361a224a9f04cebd69b9f45f7d4a064"
  end

  resource "pylsp-rope" do
    url "https://files.pythonhosted.org/packages/fe/25/1935fc44a596427d50be237658a8fd23302a7904705422a5f1e39468e921/pylsp-rope-0.1.11.tar.gz"
    sha256 "48aadf993dafa5e8fca1108b4a5431314cf80bc78cffdd56400ead9c407553be"
  end

  resource "python-lsp-black" do
    url "https://files.pythonhosted.org/packages/ad/1b/f20e612a33f9dcc2a0863a42ee62cc4f30ee724f1e7cc869b92c786c8ebd/python-lsp-black-1.3.0.tar.gz"
    sha256 "5aa257e9e7b7e5a2316ef2a9fbcd242e82e0f695bf1622e31c0bf5cd69e6113f"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/48/b6/fd92e2ea4635d88966bb42c20198df1a981340f07843b5e3c6694ba3557b/python-lsp-jsonrpc-1.1.2.tar.gz"
    sha256 "4688e453eef55cd952bff762c705cedefa12055c0aec17a06f595bcc002cc912"
  end

  resource "python-lsp-ruff" do
    url "https://files.pythonhosted.org/packages/ef/ce/1679e66e0ed90c000b1720a2131f9c8bad34d932149de519ab2e7f027c11/python-lsp-ruff-1.6.0.tar.gz"
    sha256 "bdfdd9359c9e9f55b6f6a938493d6cbace554dccacf45df4ebb36552be34e9b8"

    # this depends on `ruff` solely to install the binary,
    # but we can just depend on the `ruff` formula in Homebrew
    patch :DATA
  end

  resource "pytoolconfig" do
    url "https://files.pythonhosted.org/packages/78/ab/9e5168b7101e682e2916b5d028e9fcd857b79cbbc9a29e36b1597f3926d0/pytoolconfig-1.2.6.tar.gz"
    sha256 "f2d00ea4f8cbdffd3006780ba51016618c835b338f634e3f7f8b2715b1710889"
  end

  resource "rope" do
    url "https://files.pythonhosted.org/packages/53/38/b28a6eeaf083dcdc1c779edda80d399283fb87008fffb4a556bc3be634e2/rope-1.11.0.tar.gz"
    sha256 "ac0cbdcda5a546e1e56c54976df07ea2cb04c806f65459bc213536c5d1bc073e"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/15/16/ff0a051f9a6e122f07630ed1e9cbe0e0b769273e123673f0d2aa17fe3a36/ujson-5.8.0.tar.gz"
    sha256 "78e318def4ade898a461b3d92a79f9441e7e0e4d2ad5419abed4336d702c7425"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  def python3
    "python3.11"
  end

  def install
    virtualenv_install_with_resources

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[black mypy pydocstyle].map do |package_name|
      package = Formula[package_name].opt_libexec
      package/site_packages
    end
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
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
    output = pipe_output("#{bin}/pylsp -v 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)

    expected_plugins = %w[
      pydocstyle
      pylsp_black
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
diff --git a/pyproject.toml b/pyproject.toml
index cfdf720..d84c1b7 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -13,7 +13,6 @@ readme = "README.md"
 requires-python = ">=3.7"
 license = {text = "MIT"}
 dependencies = [
-  "ruff>=0.1.0, <0.2.0",
   "python-lsp-server",
   "lsprotocol>=2022.0.0a1",
   "tomli>=1.1.0; python_version < '3.11'",