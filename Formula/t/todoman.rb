class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/5c/18/25c3aa629d9894e2d4631385ea776414f29254936c42b4c5b6f19d228504/todoman-4.3.1.tar.gz"
  sha256 "d03c73773ca108f59383f3d950186f8978e98ed9a9657e2c89f1f8bb1da6679a"
  license "ISC"
  head "https://github.com/pimutils/todoman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "249b3ce30a69c54004e47f6b19fd9134bdae268d810541a159e46a1897302444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4684afd0c210682e18b315df03e15f5cb394cf0350b9e406e6c8f8da91d3072"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f050be3cebc464a42026921e4deec5c13c00edf539458f396c283d2e1c4655ba"
    sha256 cellar: :any_skip_relocation, ventura:        "4237c8f8db82372c68303ffc669ff4805749e5d39e1c8ce0ffde2ef24ed70bad"
    sha256 cellar: :any_skip_relocation, monterey:       "083b667953cb1c519e861f2d4bfe357e49c1c8f28ac5b2be93f00eeebe458221"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0c2706ec89d18a213f45f038268dfe161802d6a8a1100a8ab048f5b04c14c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b2dac184cb3b0967d3c28c44d4ea9a932dabf88ccde7cd5e52db85ef637367"
  end

  depends_on "jq" # Needed for ZSH completions.
  depends_on "python-pytz"
  depends_on "python@3.11"
  depends_on "six"

  conflicts_with "devtodo", because: "both install a `todo` binary"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/69/86/34d04afc5c33a31f4e9939f857e28fc9d039440f29b99a34f2190f0ab0ac/humanize-4.7.0.tar.gz"
    sha256 "7ca0e43e870981fa684acb5b062deb307218193bca1a01f2b2676479df849b3a"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/7b/cb/ab742b444f6a25a349f061f1d661060060191e065f0aa815ba1bf989bf5c/icalendar-5.0.7.tar.gz"
    sha256 "e306014a64dc4dcf638da0acb2487ee4ada57b871b03a62ed7b513dfc135655c"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
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