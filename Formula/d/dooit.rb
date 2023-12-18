class Dooit < Formula
  include Language::Python::Virtualenv

  desc "TUI todo manager"
  homepage "https:github.comkraanzudooit"
  url "https:files.pythonhosted.orgpackagesc7b38d73a4ed09c6589242adf005d3c83b662989ac944b983efbfe27fc6b3d93dooit-2.0.1.tar.gz"
  sha256 "ebf1a83a1cd6f3a101cf7a4b122790d705905540ddf89b5a4a64a4de1199c983"
  license "MIT"
  revision 1
  head "https:github.comkraanzudooit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a75312be31dfddb5435dec8bfc4b2e6cd5c45633d1cea350e7cc7e0ccc0fb238"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adfbdcf482eac4cb70a80fc20b6fd968ce0bc83c6d7444f1f40ae53f2170c5a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4370b6e22615d8a385eaa02a54bc23faeba45f8973ba85f8c878f0352b11a7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "777b43ca3324ee6b842510fe16ac83a846bf4fa8383a72d558c6c559a3bebeca"
    sha256 cellar: :any_skip_relocation, ventura:        "7a346fc1696bdc0e8c0b73e5f3299023b4d0c7183b6b717f6701f664b25df33b"
    sha256 cellar: :any_skip_relocation, monterey:       "4f31789c525c08a237c043b6d0cdb8eec07c3b0f9cc31a1153b238dcd5cc69dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bad46eebcdf24f19e1fe3db9afedc0da7cf63b85b6fbe7d8e91b23e43f6d6db"
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

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages3344ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
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
    url "https:files.pythonhosted.orgpackagesb10ee5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages26c1a03d903920167f4022e61eeff8b7280dd5fc2541147a78c90aabdd459eb2textual-0.34.0.tar.gz"
    sha256 "b66deee4afa9f6986c1bee973731d7dad2b169872377d238c9aad7141449b443"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackagesce7399e4cc30db6b21cba6c3b3b80cffc472cc5a0feaf79c290f01f1ac460710tzlocal-2.1.tar.gz"
    sha256 "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages75db241444fe6df6970a4c18d227193cad77fab7cec55d98e296099147de017fuc-micro-py-1.0.2.tar.gz"
    sha256 "30ae2ac9c49f39ac6dce743bd187fcd2b574b16ca095fa74cd9396795c954c54"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
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