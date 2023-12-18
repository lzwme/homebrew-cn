class Codelimit < Formula
  include Language::Python::Virtualenv

  desc "Your Refactoring Alarm"
  homepage "https:github.comgetcodelimitcodelimit"
  url "https:files.pythonhosted.orgpackagesefb017e7b12b587af10b1096ba44250eddc71dd28446ae4c9bac708587a0a607codelimit-0.7.0.tar.gz"
  sha256 "4e6caa1cbd85fb7989f24e3b9f151c43f28e4bb807cb2f7a3046bfd5b6872e57"
  license "ISC"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0283f6454203ca6e79693799057ddfb3a7c7b8532d23db762dc7c67a896e5190"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f85d6d3301af722c1977db2f07cd93aef3979bfb173b4c4a4fa72fd594fdbd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3802389e61570bcc5f9158ab0d39fefcbcbdf654269baf0d4f6239ff66d2a75"
    sha256 cellar: :any_skip_relocation, sonoma:         "83d91a5f42cce97d012cf1e038db647d71401dc3cd9c4552bd8fc50fe3bb1240"
    sha256 cellar: :any_skip_relocation, ventura:        "3a283b65e443a2f5494347fdd60995e1e0eaabdba1aeb7b165044ed01af1ef7f"
    sha256 cellar: :any_skip_relocation, monterey:       "7ea80e10fd440b62a0c8106c3ac1cea5ae0129785dbb9d7fce242a85b0951b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "018206355c4e273e3a0a826e0051464b2aa9f91c25e5855b824df7041ffc7ff1"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "halo" do
    url "https:files.pythonhosted.orgpackagesee48d53580d30b1fabf25d0d1fcc3f5b26d08d2ac75a1890ff6d262f9f027436halo-0.0.31.tar.gz"
    sha256 "7b67a3521ee91d53b7152d4ee3452811e1d2a6321975137762eb3d70063cc9d6"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages3344ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages8dfd73bb30ec2b3cd952fe139a79a40ce5f5fd0280dd2cc1de94c93ea6a714d2linkify-it-py-2.0.2.tar.gz"
    sha256 "19f3060727842c254c808e99d465c80c49d2c7306788140987a1a7a29b0d6ad2"
  end

  resource "log-symbols" do
    url "https:files.pythonhosted.orgpackages4587e86645d758a4401c8c81914b6a88470634d1785c9ad09823fa4a1bd89250log_symbols-0.0.14.tar.gz"
    sha256 "cf0bbc6fe1a8e53f0d174a716bc625c4f87043cc21eb55dd8a740cfe22680556"
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

  resource "plotext" do
    url "https:files.pythonhosted.orgpackages27d758f5ec766e41f8338f04ec47dbd3465db04fbe2a6107bca5f0670ced253aplotext-5.2.8.tar.gz"
    sha256 "319a287baabeb8576a711995f973a2eba631c887aa6b0f33ab016f12c50ffebe"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "spinners" do
    url "https:files.pythonhosted.orgpackagesd391bb331f0a43e04d950a710f402a0986a54147a35818df0e1658551c8d12e1spinners-0.0.24.tar.gz"
    sha256 "1eb6aeb4781d72ab42ed8a01dcf20f3002bf50740d7154d12fb8c9769bf9e27f"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackagesb885147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444ctermcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages26c1a03d903920167f4022e61eeff8b7280dd5fc2541147a78c90aabdd459eb2textual-0.34.0.tar.gz"
    sha256 "b66deee4afa9f6986c1bee973731d7dad2b169872377d238c9aad7141449b443"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackages5b4939f10d0f75886439ab3dac889f14f8ad511982a754e382c9b6ca895b29e9typer-0.9.0.tar.gz"
    sha256 "50922fd79aea2f4751a8e0408ff10d2662bd0c8bbfa84755a699f3bada2978b2"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages75db241444fe6df6970a4c18d227193cad77fab7cec55d98e296099147de017fuc-micro-py-1.0.2.tar.gz"
    sha256 "30ae2ac9c49f39ac6dce743bd187fcd2b574b16ca095fa74cd9396795c954c54"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  # upstream py3.12 report, https:github.comgetcodelimitcodelimitissues26
  # patch is already in the branch, https:github.comgetcodelimitcodelimittreeissue-26-Support_Python_3_12
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.py").write <<~EOS
      def foo():
        print('Hello world!')
    EOS

    assert_includes shell_output("#{bin}codelimit check #{testpath}test.py"), "Refactoring not necessary"
  end
end

__END__
diff --git apyproject.toml bpyproject.toml
index 0092882..1d9701c 100644
--- apyproject.toml
+++ bpyproject.toml
@@ -9,13 +9,14 @@ readme = "README.md"
 codelimit = "codelimit.__main__:cli"

 [tool.poetry.dependencies]
-python = ">=3.9,<3.12"
+python = ">=3.9,<=3.12"
 halo = "^0.0.31"
 plotext = "^5.2.8"
 pygments = "^2.13.0"
 textual = "^0.34.0"
 requests = "^2.28.2"
 typer = "^0.9.0"
+aiohttp = "^3.9.0b0"

 [tool.poe.tasks.bundle]
 help = "Create a binary executable using pyinstaller"