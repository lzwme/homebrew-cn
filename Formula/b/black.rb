class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https:black.readthedocs.ioenstable"
  url "https:files.pythonhosted.orgpackages2969f3ab49cdb938b3eecb048fa64f86bdadb1fac26e92c435d287181d543b0ablack-24.2.0.tar.gz"
  sha256 "bce4f25c27c3435e4dace4815bcb2008b87e167e3bf4ee47ccdc5ce906eb4894"
  license "MIT"
  head "https:github.compsfblack.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?packages.*?black[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5504b38c625b296082d373ee080be8e1d950a0ba0fd1ff35dbcce4212ce8ea23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a280625ab739253b1290688a8acc86a7492cab1f9738866cae2d9f91217e8d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "285591f25052d1e04ba594ee47b4a018e05c6b60ccb8e7544e97352aaea7ad55"
    sha256 cellar: :any_skip_relocation, sonoma:         "42fb1dd41513bfccae0e9c225f646aa0d0a40b58056a899e8bcb9a82fda1ad55"
    sha256 cellar: :any_skip_relocation, ventura:        "d00bace045f166637edac431315065a25f9ab987dd226f54918d28924031ad37"
    sha256 cellar: :any_skip_relocation, monterey:       "ba282b7ac6d807a6955464f3a3ebcce1c5e726ce1097f0071a5f1671d252196e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd91ecf5306d39bb047953288717bf01823e92a91db7e93cc10ae1930bdd4a0"
  end

  depends_on "python-attrs"
  depends_on "python-click"
  depends_on "python-idna"
  depends_on "python-packaging"
  depends_on "python-pathspec"
  depends_on "python-platformdirs"
  depends_on "python@3.12"

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages18931f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258baiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "mypy-extensions" do
    url "https:files.pythonhosted.orgpackages98a41ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3fmypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"black", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  service do
    run opt_bin"blackd"
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var"logblackd.log"
    error_log_path var"logblackd.log"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath"black_test.py").write <<~EOS
      print(
      'It works!')
    EOS
    system bin"black", "black_test.py"
    assert_equal "print(\"It works!\")\n", (testpath"black_test.py").read
    port = free_port
    fork { exec "#{bin}blackd --bind-host 127.0.0.1 --bind-port #{port}" }
    sleep 10
    assert_match "print(\"valid\")", shell_output("curl -s -XPOST localhost:#{port} -d \"print('valid')\"").strip
  end
end