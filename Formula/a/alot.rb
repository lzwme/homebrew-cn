class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  url "https://ghproxy.com/https://github.com/pazz/alot/archive/refs/tags/0.10.tar.gz"
  sha256 "71f382aa751fb90fde1a06a0a4ba43628ee6aa6d41b5cd53c8701fd7c5ab6e6e"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/pazz/alot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3f276294305f8b3feed95adcb161802a7e976fc3a7b34f25a983fafe343f19b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19b6f9aad8624ac916f1cb622510ae2f3ce8154b8aabecb16b37d8f0f06f9fb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d0eea5746c75674d117b66b14eb0087701955c1afd1bbf06344b2e092bc4c77"
    sha256 cellar: :any_skip_relocation, sonoma:         "a31fe0d674dcc352a11edc69a97719fd64c65734f0a8531985863cd780926710"
    sha256 cellar: :any_skip_relocation, ventura:        "9727b2d3460d945be287616dfa8409825f5bc0ef7c542af9794f0c4ee6a3d8b4"
    sha256 cellar: :any_skip_relocation, monterey:       "b8bc209f4d604bd84890f2f7cbbb60016eaf3cfda765821f03ed64786b5296f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a68a78ee5375be349cc6bf57deb27287af479af989cc3c647cec0a5d4f78df4"
  end

  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libmagic"
  depends_on "notmuch"
  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/7a/7b/9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4/Automat-22.10.0.tar.gz"
    sha256 "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/86/42/9e87f04fa2cd40e3016f27a4b4572290e95899c6dce317e2cdb580f3ff09/incremental-22.10.0.tar.gz"
    sha256 "912feeb5e0f7e0188e6f42241d2f450002e11bbc0937c65865045854c24c0bd0"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/66/ab/41d09a46985ead5839d8be987acda54b5bb93f713b3969cc0be4f81c455b/mock-5.1.0.tar.gz"
    sha256 "5e96aad5ccda4718e0a229ed94b2024df75cc2d55575ba5762d31f5767b8767d"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/5b/6c/d58b1bfc47cf02bd282f32fee9bd74d834fb2a92fdedf3e56f1ddb778c18/twisted-23.8.0.tar.gz"
    sha256 "3c73360add17336a622c0d811c2a2ce29866b6e59b1125fd6509b17252098a24"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/81/f4/fa6da5de99e11e60d826567609eaa815146f835285a26f6c0f61e6015e2c/urwid-2.2.3.tar.gz"
    sha256 "e4516d55dcee6bd012b3e72a10c75f2866c63a740f0ec4e1ada05c1e1cc02e34"
  end

  resource "urwidtrees" do
    url "https://files.pythonhosted.org/packages/43/e1/ca5cf122cf1121b55acb39a1fb7e9fb1283c2eb0dc75fca751eb8c16b2f9/urwidtrees-1.0.3.tar.gz"
    sha256 "50b19c06b03a5a73e561757a26d449cfe0c08afabe5c0f3cd4435596bdddaae9"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/87/03/6b85c1df2dca1b9acca38b423d1e226d8ffdf30ebd78bcb398c511de8b54/zope.interface-6.1.tar.gz"
    sha256 "2fdc7ccbd6eb6b7df5353012fbed6c3c5d04ceaca0038f75e601060e95345309"
  end

  def install
    virtualenv_install_with_resources

    # Add path configuration file to use notmuch CFFI bindings
    site_packages = Language::Python.site_packages("python3.12")
    pth_contents = "import site; site.addsitedir('#{Formula["notmuch"].opt_libexec/site_packages}')\n"
    (libexec/site_packages/"homebrew-notmuch2.pth").write pth_contents

    pkgshare.install Pathname("extra").children - [Pathname("extra/completion")]
    zsh_completion.install "extra/completion/alot-completion.zsh" => "_alot"

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["SPHINXBUILD"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"
    cd "docs" do
      system "make", "pickle"
      system "make", "man", "html"
      man1.install "build/man/alot.1"
      doc.install Pathname("build/html").children
    end
  end

  test do
    (testpath/".notmuch-config").write <<~EOS
      [database]
      path=#{testpath}/Mail
    EOS
    (testpath/"Mail").mkpath
    system Formula["notmuch"].bin/"notmuch", "new"

    require "pty"
    PTY.spawn(bin/"alot", "--logfile", testpath/"out.log") do |_r, _w, pid|
      sleep 10
      Process.kill 9, pid
    end

    assert_predicate testpath/"out.log", :exist?, "out.log file should exist"
    assert_match "setup gui", (testpath/"out.log").read
  end
end