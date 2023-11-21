class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/fd/60/dbd18038cfe5a795d2e427b3ae4112c340966ed2d3a70303a4d59d7313eb/todoman-4.4.0.tar.gz"
  sha256 "0b7beeb8c73bfa299147288d9b657bc4e0e288febb84e198ef72cb1412af9db6"
  license "ISC"
  head "https://github.com/pimutils/todoman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "635aa8bb34f25780c9f3b708e4ab45835a50cac7fae2ea25756938403bd49ce1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5feec760f05f90947b07b6c0a26e84e01da3b567c2d578cdcd4c147669887f3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199d07cf33110761686a8241a83940e1b4a808e875462859a2f2d404659e6b7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6a01c860ac96487c47744072df697c925f89890308c7726f50bf80cc9228a16"
    sha256 cellar: :any_skip_relocation, ventura:        "2583c45b8ec7953f2c6b209a5a7c2fa58310842cb82bf9e2df5baa0f989235fa"
    sha256 cellar: :any_skip_relocation, monterey:       "b514aa8af8e9f7222f4a2aa29c37e341f0db53a80352d367910ee3087d88cdef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c754a9b585dcc35fb97d5912327f21858331ae8847c44d439442c714fffcf9"
  end

  depends_on "jq" # Needed for ZSH completions.
  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "six"

  conflicts_with "devtodo", because: "both install a `todo` binary"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0c/84/e58c665f4ebb03d2fbeb28b51afb0743f846db18a5b594ed8b8973676ddf/humanize-4.8.0.tar.gz"
    sha256 "9783373bf1eec713a770ecaa7c2d7a7902c98398009dfa3d8a2df91eec9311e8"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/6c/23/187a28257fe26848d07af225cef86abe3712561bd8af93cbd3a64d6eb6ea/icalendar-5.0.11.tar.gz"
    sha256 "7a298bb864526589d0de81f4b736eeb6ff9e539fefb405f7977aa5c1e201ca00"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/81/f4/fa6da5de99e11e60d826567609eaa815146f835285a26f6c0f61e6015e2c/urwid-2.2.3.tar.gz"
    sha256 "e4516d55dcee6bd012b3e72a10c75f2866c63a740f0ec4e1ada05c1e1cc02e34"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "contrib/completion/bash/_todo" => "todo"
    zsh_completion.install "contrib/completion/zsh/_todo"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/".config/todoman/config.py").write <<~EOS
      path = "#{testpath}/.calendar/*"
      date_format = "%Y-%m-%d"
      default_list = "Personal"
    EOS
    (testpath/".calendar/Personal").mkpath
    system "#{bin}/todo", "new", "newtodo"
    assert_match "newtodo", shell_output("#{bin}/todo list")
  end
end