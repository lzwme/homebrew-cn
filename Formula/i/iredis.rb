class Iredis < Formula
  include Language::Python::Virtualenv

  desc "Terminal Client for Redis with AutoCompletion and Syntax Highlighting"
  homepage "https://iredis.io"
  url "https://files.pythonhosted.org/packages/33/30/bf585c76653873b74b9bfebf1fdb22aee4e6959f37e68d8a883684a7ec95/iredis-1.13.2.tar.gz"
  sha256 "7645fe5e153c12e231f68e58067bcc678dce2a61ee572bb0992dbe7159b85302"
  license "BSD-3-Clause"
  head "https://github.com/laixintao/iredis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "381dad8d3d7a61e8f42ba539172b962668b34a7ab66de8b9478147079c4837da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b906bf824b8b55ae5da4e36ed97fc91df4b4185b0f13490aa52f1531f9b5e21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26804f1bfe18b0a747415690e288612661463eac14186cbd084b2da41b88f107"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa168c5d49740166313eaefe13c23ccab59151fecd1cec37cd1f74f8786664c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "cda36614fc168be8a2710bfa357b3bfcc6ce97a6636a0008ac67c3fb24ea31c6"
    sha256 cellar: :any_skip_relocation, ventura:        "583312f7a8cef8bfd8ecbd515f3d4fdc703ad620352435245dd9c10b802f7431"
    sha256 cellar: :any_skip_relocation, monterey:       "7f2d111e436fdd0c9f61f583872a86f85df15a7f0933f068a58afe3057251e6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "58d718b3b4d240a9171b408b518b6cacd43a4ce83dbc0a217d9e40f1f6123c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2430b7d0e7ef3a5bbac0e3dbda84ca13a4417fce08ff6202566f65300cb01b07"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/0c/88/6862147c3203750cef135070fe9f841d82146c4206f55239592bcc27b0cd/mistune-3.0.1.tar.gz"
    sha256 "e912116c13aa0944f9dc530db38eb88f6a77087ab128f49f84a48f4c05ea163c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/db/15/6e89ae7cde7907118769ed3d2481566d05b5fd362724025198bb95faf599/pendulum-2.1.2.tar.gz"
    sha256 "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytzdata" do
    url "https://files.pythonhosted.org/packages/67/62/4c25435a7c2f9c7aef6800862d6c227fc4cd81e9f0beebc5549a49c8ed53/pytzdata-2020.1.tar.gz"
    sha256 "3efa13b335a00a8de1d345ae41ec78dd11c9f8807f522d39850f2dd828681540"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/73/88/63d802c2b18dd9eaa5b846cbf18917c6b2882f20efda398cc16a7500b02c/redis-4.6.0.tar.gz"
    sha256 "585dc516b9eb042a619ef0a39c3d7d55fe81bdb4df09a52c9cdde0d07bf1aa7d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when merged/released: https://github.com/sdispater/pytzdata/pull/13
    resource("pytzdata").stage do
      inreplace "pyproject.toml", 'requires = ["poetry>=1.0.0"]', 'requires = ["poetry-core>=1.0"]'
      inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'
      venv.pip_install_and_link Pathname.pwd
    end

    venv.pip_install resources.reject { |r| r.name == "pytzdata" }
    venv.pip_install_and_link buildpath
  end

  test do
    port = free_port
    output = shell_output("#{bin}/iredis -p #{port} info 2>&1", 1)
    assert_match "Connection refused", output
  end
end