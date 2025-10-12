class Jupytext < Formula
  include Language::Python::Virtualenv

  desc "Jupyter notebooks as Markdown documents, Julia, Python or R scripts"
  homepage "https://jupytext.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/15/14/41faf71e168fcc6c48268f0fc67ba0d6acf6ee4e2c5c785c2bccb967c29d/jupytext-1.17.3.tar.gz"
  sha256 "8b6dae76d63c95cad47b493c38f0d9c74491fb621dcd0980abfcac4c8f168679"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ba7a1ae7e62e48fbefe93658d3a2806d05ea5b9af43645411fe54becdd1abfa4"
    sha256 cellar: :any,                 arm64_sequoia: "5acffb82e831727d0cf97eaf379960aeb8a35c3cc7ba66bffedbf843b06024bb"
    sha256 cellar: :any,                 arm64_sonoma:  "640cc79b6cb8e65d4081bf4078775dcb59d6da715114f912784074d17acd75e5"
    sha256 cellar: :any,                 sonoma:        "2a2907d60bb248d8c2bf5f33cfcbd8df77779c0837d35246638981b61981d351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12a75517ff219520464761b4cc6482d4421d517aca4b6d214c0232700a8b2183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82add6cf854568e942f148f75f7cf4039a5121c03e2c55c4f5071c8d6c5571d2"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/20/b5/23b216d9d985a956623b6bd12d4086b60f0059b27799f23016af04a74ea1/fastjsonschema-2.21.2.tar.gz"
    sha256 "b1eb43748041c880796cd077f1a07c3d94e93ae84bba5ed36800a33554ae05de"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/99/1b/72906d554acfeb588332eaaa6f61577705e9ec752ddb486f302dafa292d9/jupyter_core-5.8.1.tar.gz"
    sha256 "0a5f9706f70e64786b75acba995988915ebd4601c8a52e534a40b51c95f59941"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/6d/fd/91545e604bc3dad7dca9ed03284086039b294c6b3d75c0d2fa45f9e9caf3/nbformat-5.10.4.tar.gz"
    sha256 "322168b14f937a5d11362988ecac2a4952d3d8e3a2cbeb2319584631226d5b3a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/eb/79/72064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574/traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jupytext --version")

    (testpath/"notebook.ipynb").write <<~JSON
      {
        "cells": [
          {
            "cell_type": "code",
            "execution_count": null,
            "metadata": {},
            "outputs": [],
            "source": [
              "print('Hello, World!')"
            ]
          }
        ],
        "metadata": {},
        "nbformat": 4,
        "nbformat_minor": 5
      }
    JSON

    system bin/"jupytext", "--to", "py", "notebook.ipynb"
    assert_path_exists testpath/"notebook.py"
    assert_match "print('Hello, World!')", (testpath/"notebook.py").read
  end
end