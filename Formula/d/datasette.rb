class Datasette < Formula
  include Language::Python::Virtualenv
  desc "Open source multi-tool for exploring and publishing data"
  homepage "https:docs.datasette.ioenstable"
  url "https:files.pythonhosted.orgpackagesc87d667e3bfceef9e428e38117b8d9704f502395fddc1effb7ef760b2dd0c4e6datasette-0.64.6.tar.gz"
  sha256 "85ca3aabca64fd9560052042aec27d3b32a1f85303853da3550434866d0fa539"
  license "Apache-2.0"
  revision 2
  head "https:github.comsimonwdatasette.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "162667b4aa256499b2648c615e0d21d6a1ed86ecdb17c04b261a6ac6ba53a3ad"
    sha256 cellar: :any,                 arm64_ventura:  "787476fea649f6e891a0a10c3beebd46e7eab5219149bd6a0c58fc002896899a"
    sha256 cellar: :any,                 arm64_monterey: "6d0fd8eff92c21f838f303642a36c8b00f5b3e5b39484b482be6245fc07254ae"
    sha256 cellar: :any,                 sonoma:         "358b839cebf0db834369af3e9c6151d625c31bbde0249aff3b327bc364815c7e"
    sha256 cellar: :any,                 ventura:        "f1774e7fddfa4e512fc0ceeb57278933c5f9cc07a58ad7b4e185788e28bfca21"
    sha256 cellar: :any,                 monterey:       "c7120318db2a851d3b4e12cd1280d9439f91634c69c3faa7740d0cb7b4c52f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f558cf2fe176526d4bc8d4e31f142bba7b71bfeecd979304362a634e0036ccf9"
  end

  depends_on "libyaml"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackagesaf41cfed10bc64d774f497a86e5ede9248e1d062db675504b41c320954d99641aiofiles-23.2.1.tar.gz"
    sha256 "84ec2218d8419404abcb9f0c02df3f34c6e0a68ed41072acfb1cef5cbc29051a"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesdb4d3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "asgi-csrf" do
    url "https:files.pythonhosted.orgpackages299c13d880d7ebe13956c037864eb7ac9dbcd0260d4c47844786f07ccca897e1asgi-csrf-0.9.tar.gz"
    sha256 "6e9d3bddaeac1a8fd33b188fe2abc8271f9085ab7be6e1a7f4d3c9df5d7f741a"
  end

  resource "asgiref" do
    url "https:files.pythonhosted.orgpackages121964e38c1c2cbf0da9635b7082bbdf0e89052e93329279f59759c24a10cc96asgiref-3.7.2.tar.gz"
    sha256 "9e0ce3aa93a819ba5b45120216b23878cf6e8525eb3848653452b4192b92afed"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https:files.pythonhosted.orgpackages1dceedb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41dfclick_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages94f147528a2f465b09c71caad95f5de1d7225e438cf3d1068d278362a4a6bc6ahttpcore-1.0.3.tar.gz"
    sha256 "5c0f9546ad17dac4d0772b0808856eb616eb8b48ce94f49ed819fd6982a8a544"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesbd262dc654950920f499bd062a211071925533f821ccdca04fa0c2fd914d5d06httpx-0.26.0.tar.gz"
    sha256 "451b55c30d5185ea6b23c2c793abf9bb237d2a7dfb901ced6ff69ad37ec1dfaf"
  end

  resource "hupper" do
    url "https:files.pythonhosted.orgpackagesbde6bb064537288eee2be97f3e0fcad8e7242bc5bbe9664ae57c7d29b3fa18c2hupper-1.12.1.tar.gz"
    sha256 "06bf54170ff4ecf4c84ad5f188dee3901173ab449c2608ad05b9bfd6b13e32eb"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages7fa1d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "janus" do
    url "https:files.pythonhosted.orgpackagesb8a8facab7275d7d3d2032f375843fe46fad1cfa604a108b5a238638d4615bdcjanus-1.0.0.tar.gz"
    sha256 "df976f2cdcfb034b147a2d51edfc34ff6bfb12d4e2643d3ad0e10de058cb1612"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "pint" do
    url "https:files.pythonhosted.orgpackages0241002d020f140db35d971f4bdd73407d69fdf56c5ba5fcccc10776e27d3a6cPint-0.23.tar.gz"
    sha256 "e1509b91606dbc52527c600a4ef74ffac12fff70688aff20e9072409346ec9b4"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages54c643f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "python-multipart" do
    url "https:files.pythonhosted.orgpackages5c0f9c55ac6c84c0336e22a26fa84ca6c51d58d7ac3a2d78b0dfa8748826c883python_multipart-0.0.9.tar.gz"
    sha256 "03f54688c663f1b7977105f021043b0793151e4cb1c1a9d4a11fc13d622c4026"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc93d74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fadsetuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages0c1deb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackages09d88aa69c76585035ca81851d99c3b00fd6be050aefd478a5376ff9fc5feb69uvicorn-0.27.1.tar.gz"
    sha256 "3d9a267296243532db80c83a959a3400502165ade2c1338dea4e67915fd4745a"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[uvicorn].map { |p| Formula[p].opt_libexecsite_packages }
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")

    generate_completions_from_executable(bin"datasette", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "15", shell_output("#{bin}datasette --get '_memory.json?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}datasette --get ''")
  end
end