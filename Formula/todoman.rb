class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/6c/0e/5a3ed2a34251625f8483f844ba0dba4bf903b0db8b63e87a70666eea7ee7/todoman-4.2.1.tar.gz"
  sha256 "b69afe914c8fb0f9387d61c86c9bf2e8ba17717bf3f9cfb1b711e3c87a773b85"
  license "ISC"
  head "https://github.com/pimutils/todoman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1cb4fa375427746cc480f2ab1d000b2a41ebea837a9cea15107feb749bbaeac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f2cb317fca23069023cb40347899549ce36606f325eb47e114c94fcfe5e0a17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a7e1272f60fc31927c8416d10e853e47ab51e70a7fc7c6d07ef428d6ff96eb4"
    sha256 cellar: :any_skip_relocation, ventura:        "65dd479f498884884f6f44861b2e2a94a16dd9804ca0bd10c3c7780124e7fb30"
    sha256 cellar: :any_skip_relocation, monterey:       "92a56bd07295872f1035947a8b861cd03b712225fe2e9697646663c3c73f30f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "79f07f67ce90921db8407fef153987fef1c2030a6867530594c22d35aba99ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c2485fe6e45aa443c1061ae299c9c686d9e8ef9bf758e6e9c91c8516e3d6010"
  end

  depends_on "jq" # Needed for ZSH completions.
  depends_on "python@3.11"
  depends_on "six"

  conflicts_with "devtodo", because: "both install a `todo` binary"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/06/b1/9e491df2ee1c919d67ee328d8bc9f17b7a9af68e4077f3f5fac83a4488c9/humanize-4.6.0.tar.gz"
    sha256 "5f1f22bc65911eb1a6ffe7659bd6598e33dcfeeb904eb16ee1e705a09bf75916"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/00/55/4575f67b1d6e174dfdfec016decf250e3dd9019372dd9fb73187b89531d7/icalendar-5.0.4.tar.gz"
    sha256 "f0aa86d6f5bc110ed3b91e96c48c70351d7a09fbed25366f673dc0b799c83975"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/55/71/cb1b0a0035cf479eaf05109ea830323af66d48197bfc759a018f94acc3c4/pytz-2023.2.tar.gz"
    sha256 "a27dcf612c05d2ebde626f7d506555f10dfc815b3eddccfaadfc7d99b11c9a07"
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