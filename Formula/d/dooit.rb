class Dooit < Formula
  include Language::Python::Virtualenv

  desc "TUI todo manager"
  homepage "https:github.comkraanzudooit"
  url "https:files.pythonhosted.orgpackages56868c99cbaa2da2573af9e8a8c263ea135e29fab3ce3acacdd5b314cd57efecdooit-2.1.1.tar.gz"
  sha256 "1c75fb2a421aad8cd19646f334aadcd1caacfb895bdf55e4feb7e638337815eb"
  license "MIT"
  head "https:github.comkraanzudooit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3036099f9bc506fb06d95671a0f52bfc220657f88668c9444a257ffaedd20f91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "176e0e48976e929b50ff1aac249de228b422d2ff68b8cacfb81250437798a4de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2a1cd2f3f51f3487c913eac49ad26147c965735b998292f513d7ec6212f1691"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c3f0cfd62ee06f6265a4082da5c3d1bf9b0f4bfa4d88ecf726d93345cd496b2"
    sha256 cellar: :any_skip_relocation, ventura:        "87d68f48deced7def5ba9bbf70917acd14ed2a7f02b230053881706df5788ac0"
    sha256 cellar: :any_skip_relocation, monterey:       "54b8dd25ecdf0cb055bbcfcabfa22ace5a4d0cf815be288e7020f84dd1f13571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da85b37ed0d8cb621674f9997bf1a10bb5055d57e930fa9d28f1ac0d85b04f02"
  end

  depends_on "cmake" => :build
  depends_on "pygments"
  depends_on "python-pytz"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "virtualenv"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages8dfd73bb30ec2b3cd952fe139a79a40ce5f5fd0280dd2cc1de94c93ea6a714d2linkify-it-py-2.0.2.tar.gz"
    sha256 "19f3060727842c254c808e99d465c80c49d2c7306788140987a1a7a29b0d6ad2"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdit-py-plugins" do
    url "https:files.pythonhosted.orgpackagesb4db61960d68d5c39ff0dd48cb799a39ae4e297f6e9b96bf2f8da29d897fba0cmdit_py_plugins-0.4.0.tar.gz"
    sha256 "d8ab27e9aed6c38aa716819fedfde15ca275715955f8a185a8e1cf90fb1d2c1b"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackagesa72c4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages245157eb835afc9569d32b5979ecbf3bf73f8ece8700ebffab3bac7ff29f92e4textual-0.47.1.tar.gz"
    sha256 "4b82e317884bb1092f693f474c319ceb068b5a0b128b121f1aa53a2d48b4b80c"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackagesce7399e4cc30db6b21cba6c3b3b80cffc472cc5a0feaf79c290f01f1ac460710tzlocal-2.1.tar.gz"
    sha256 "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages75db241444fe6df6970a4c18d227193cad77fab7cec55d98e296099147de017fuc-micro-py-1.0.2.tar.gz"
    sha256 "30ae2ac9c49f39ac6dce743bd187fcd2b574b16ca095fa74cd9396795c954c54"
  end

  def install
    virtualenv_install_with_resources

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexecsite_packages"homebrew-virtualenv.pth").write virtualenvsite_packages
  end

  test do
    PTY.spawn(bin"dooit") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      # Create a topic
      w.write "a"
      sleep 1
      w.write "Test Topic"
      sleep 1
      w.write "\e"
      sleep 1
      # Create a todo in the topic
      w.write "\n"
      sleep 1
      w.write "a"
      sleep 1
      w.write "Test Todo"
      sleep 1
      w.write "\e"
      sleep 1
      # Exit
      w.write "\x03"
      begin
        r.read
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end
  end
end