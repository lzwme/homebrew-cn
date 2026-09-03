class Copier < Formula
  include Language::Python::Virtualenv

  desc "Utility for rendering projects templates"
  homepage "https://copier.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/a8/48/8bec3ab9ffb8937f8231a638968b6ff302f80d984aae53d120a0645bb9be/copier-9.18.1.tar.gz"
  sha256 "79ca8ff91d5749652f9b3ed8e7651545c0b611ee9277f4550737078a30ef29fc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9ad31600fe9c31079259e5da9c9644bac8334d1b8254b1f9d5b161a37c83e6ee"
    sha256 cellar: :any, arm64_sequoia: "21b140280c48fc9cd9eb98f05336abc8cc2c81d8d8349a847d2dbf9d5ba0f2ba"
    sha256 cellar: :any, arm64_sonoma:  "526f4978e2251df51cb8ab68f7bab7d1bee02532b5383cca1f995ee18f588065"
    sha256 cellar: :any, arm64_linux:   "3db59c740377a3539df38455a9b2e412858ddfcb614a2193105789362f9c3682"
    sha256 cellar: :any, x86_64_linux:  "c7442b5a4d86eb5529096a88b34ca17f294bc58388b2a624470c6869db3744fd"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pydantic"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/12/18/020d3b27a10450ddb11429f637404e8ea67ecf4d9fd999d4f1d553f25506/dunamai-1.26.2.tar.gz"
    sha256 "84ea45eddf9bb4b40df7610b1b22a03137365e6257dbf9d7b72128fdccca564c"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/70/b8/c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32/funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jinja2-ansible-filters" do
    url "https://files.pythonhosted.org/packages/1a/27/fa186af4b246eb869ffca8ffa42d92b05abaec08c99329e74d88b2c46ec7/jinja2-ansible-filters-1.3.2.tar.gz"
    sha256 "07c10cf44d7073f4f01102ca12d9a2dc31b41d47e4c61ed92ef6a6d2669b356b"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/69/b7/802a56eca9f2fac455b8bab5375a2647b0f0e14a2cd63ef077de3c4a7658/platformdirs-4.11.7.tar.gz"
    sha256 "4f41487eeeeeb07f3a6625e61d9bc0ae6809f92d3386dbd74392fbb76108104d"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/6c/d2/578712a979a50e9aba08ea173a38e7598461130d3c9899f176373bc03280/plumbum-2.0.2.tar.gz"
    sha256 "233751d7819c9e6743ec1c2405927eb4fa52a284c7b894bd10e28106a9309a92"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/f6/45/eafb0bba0f9988f6a2520f9ca2df2c82ddfa8d67c95d6625452e97b204a5/questionary-2.1.1.tar.gz"
    sha256 "3d7e980292bb0107abaa79c68dd3eee3c561b83a0f89ae482860b181c8bd412d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/36/57/ed58088fafdf4c55a0ad6bde846502567645424d7ebf325230b9237f4085/wcwidth-0.8.3.tar.gz"
    sha256 "d128512515fbf4612e0ff21fd6380399210318b7b54a9af59dff8454cf9730eb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    params = %w[
      -d python=true
      -d js=true
      -d ansible=false
      -d biggest_kbs=1000
      -d main_branches=null
      -d github=true
    ]
    system bin/"copier", "copy", *params, "--vcs-ref=v0.1.0",
      "https://github.com/copier-org/autopretty.git", "template"
    assert (testpath/"template").directory?
    assert_path_exists testpath/"template/.copier-answers.autopretty.yml"
  end
end