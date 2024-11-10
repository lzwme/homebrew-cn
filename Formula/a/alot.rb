class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https:github.compazzalot"
  # TODO: check if we can remove `standard-mailcap` from pypi_formula_mappings.json
  # https:github.compazzalotissues1632
  url "https:github.compazzalot.git",
      tag:      "0.11",
      revision: "a8a108e2344656a13bca21211ccc0df2414cbef6"
  license "GPL-3.0-only"
  revision 1
  head "https:github.compazzalot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff5d90b1a2b335e78f0a2a26a452dcc05620ec910645330ea7fd9be8cdf72152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78e840e2fafaac627380575d0e855ee986af666c7f5603c605eb2d4b272cf268"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a6ce0bd0798bca5bd5eaf719c839525208847eecc968cfd29d28ece2e63394a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9365d1c64fbc74200b5e64d8a4bdf04666d4e1775c4d5c9e626aed0faf783acc"
    sha256 cellar: :any_skip_relocation, ventura:       "a999f33e1e8db8fa7d588e448395f6e2816a6ee3a88ed031580cf81331854f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9fe0e18bbd0fde515a158f77ba00c50045f1e3b60d1bd2b36da91be030214a7"
  end

  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libmagic"
  depends_on "notmuch"
  depends_on "python@3.13"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "automat" do
    url "https:files.pythonhosted.orgpackages8d2dede4ad7fc34ab4482389fa3369d304f2fa22e50770af706678f6a332fa82automat-24.8.1.tar.gz"
    sha256 "b34227cf63f6325b8ad2399ede780675083e439b20c323d376373d8ee6306d88"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagescb8717d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fbconfigobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "constantly" do
    url "https:files.pythonhosted.orgpackages4d6fcb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324dconstantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "hyperlink" do
    url "https:files.pythonhosted.orgpackages3a511947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412ehyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages006f93e724eafe34e860d15d37a4f72a1511dd37c43a76a8671b22a15029d545idna-3.9.tar.gz"
    sha256 "e5c5dafde284f26e9e0f28f6ea2d6400abd5ca099864a67f576f3981c6476124"
  end

  resource "incremental" do
    url "https:files.pythonhosted.orgpackages2787156b374ff6578062965afe30cc57627d35234369b3336cf244b240c8d8e6incremental-24.7.2.tar.gz"
    sha256 "fb4f1d47ee60efe87d4f6f0ebb5f70b9760db2b2574c59c8e8912be4ebd464c9"
  end

  resource "mock" do
    url "https:files.pythonhosted.orgpackages66ab41d09a46985ead5839d8be987acda54b5bb93f713b3969cc0be4f81c455bmock-5.1.0.tar.gz"
    sha256 "5e96aad5ccda4718e0a229ed94b2024df75cc2d55575ba5762d31f5767b8767d"
  end

  resource "python-magic" do
    url "https:files.pythonhosted.orgpackagesdadb0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages3e2cf0a538a2f91ce633a78daaeb34cbfb93a54bd2132a6de1f6cec028eee6efsetuptools-74.1.2.tar.gz"
    sha256 "95b40ed940a1c67eb70fc099094bd6e99c6ee7c23aa2306f4d2697ba7916f9c6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "standard-mailcap" do
    url "https:files.pythonhosted.orgpackages53e8672bd621c146b89667a2bfaa58a1384db13cdd62bb7722ddb8d672bf7a75standard_mailcap-3.13.0.tar.gz"
    sha256 "19ed7955dbeaccb35e8bb05b2b5443ce55c1f932a8cbe7a5c13d42f9db4f499a"
  end

  resource "twisted" do
    url "https:files.pythonhosted.orgpackages8bbff30eb89bcd14a21a36b4cd3d96658432d4c590af3c24bbe08ea77fa7bbbbtwisted-24.7.0.tar.gz"
    sha256 "5a60147f044187a127ec7da96d170d49bcce50c6fd36f594e60f4587eff4d394"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urwid" do
    url "https:files.pythonhosted.orgpackages85b7516b0bbb7dd9fc313c6443b35d86b6f91b3baa83d2c4016e4d8e0df5a5e3urwid-2.6.15.tar.gz"
    sha256 "9ecc57330d88c8d9663ffd7092a681674c03ff794b6330ccfef479af7aa9671b"
  end

  resource "urwidtrees" do
    url "https:files.pythonhosted.orgpackages43e1ca5cf122cf1121b55acb39a1fb7e9fb1283c2eb0dc75fca751eb8c16b2f9urwidtrees-1.0.3.tar.gz"
    sha256 "50b19c06b03a5a73e561757a26d449cfe0c08afabe5c0f3cd4435596bdddaae9"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "zope-interface" do
    url "https:files.pythonhosted.orgpackagesc8837de03efae7fc9a4ec64301d86e29a324f32fe395022e3a5b1a79e376668ezope.interface-7.0.3.tar.gz"
    sha256 "cd2690d4b08ec9eaf47a85914fe513062b20da78d10d6d789a792c0b20307fb1"
  end

  def install
    venv = virtualenv_install_with_resources

    pkgshare.install Pathname("extra").children - [Pathname("extracompletion")]
    zsh_completion.install "extracompletionalot-completion.zsh" => "_alot"

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["SPHINXBUILD"] = Formula["sphinx-doc"].opt_bin"sphinx-build"
    ENV.prepend_path "PYTHONPATH", venv.site_packages
    cd "docs" do
      system "make", "pickle"
      system "make", "man", "html"
      man1.install "buildmanalot.1"
      doc.install Pathname("buildhtml").children
    end
  end

  test do
    (testpath".notmuch-config").write <<~EOS
      [database]
      path=#{testpath}Mail
    EOS
    (testpath"Mail").mkpath
    system Formula["notmuch"].bin"notmuch", "new"

    require "pty"
    PTY.spawn(bin"alot", "--logfile", testpath"out.log") do |_r, _w, pid|
      sleep 10
      Process.kill 9, pid
    end

    assert_predicate testpath"out.log", :exist?, "out.log file should exist"
    assert_match "setup gui", (testpath"out.log").read
  end
end