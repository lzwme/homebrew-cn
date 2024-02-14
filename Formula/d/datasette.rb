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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddab20ef7926ca48789bf6f0d60d34f1252c3a490d71ef74e89852b301962f8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca6c574239d7e93c01a72a0882dbe69ddbbef1778eb31e93abcc1e5b38529c58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77792c5def667d4a6b605dc429a3ec9bd3f1d4f930cafb452f0b58c44dbbdb14"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf62e1f2141efdc209c2e1d7b46a3f0d736adb274005708b3c2286a3cf4d9f32"
    sha256 cellar: :any_skip_relocation, ventura:        "9b3ff1bab4363136c77eb266438d130c50c7ad6db0babc1c601e90b758e86304"
    sha256 cellar: :any_skip_relocation, monterey:       "6f5b65626f0e1c37bf32c19e33c0d8623ca88f55e060a75191c3e5dd068bd21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "979764037ffe315001139553968b50db7b897d0772cc8e58cd86e1b9e8cfa72a"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "uvicorn"

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackagesaf41cfed10bc64d774f497a86e5ede9248e1d062db675504b41c320954d99641aiofiles-23.2.1.tar.gz"
    sha256 "84ec2218d8419404abcb9f0c02df3f34c6e0a68ed41072acfb1cef5cbc29051a"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages2db87333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "asgi-csrf" do
    url "https:files.pythonhosted.orgpackages299c13d880d7ebe13956c037864eb7ac9dbcd0260d4c47844786f07ccca897e1asgi-csrf-0.9.tar.gz"
    sha256 "6e9d3bddaeac1a8fd33b188fe2abc8271f9085ab7be6e1a7f4d3c9df5d7f741a"
  end

  resource "asgiref" do
    url "https:files.pythonhosted.orgpackages121964e38c1c2cbf0da9635b7082bbdf0e89052e93329279f59759c24a10cc96asgiref-3.7.2.tar.gz"
    sha256 "9e0ce3aa93a819ba5b45120216b23878cf6e8525eb3848653452b4192b92afed"
  end

  resource "click-default-group" do
    url "https:files.pythonhosted.orgpackages1dceedb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41dfclick_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages185678a38490b834fa0942cbe6d39bd8a7fd76316e8940319305a98d2b320366httpcore-1.0.2.tar.gz"
    sha256 "9fc092e4799b26174648e54b74ed5f683132a464e95643b226e00c2ed2fa6535"
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

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc93d74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fadsetuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
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