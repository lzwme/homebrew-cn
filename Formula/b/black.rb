class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https:black.readthedocs.ioenstable"
  url "https:files.pythonhosted.orgpackages5a73618bcfd4a4868d52c02ff7136ec60e9d63bc83911d3d8b4998e42acf9557black-23.12.0.tar.gz"
  sha256 "330a327b422aca0634ecd115985c1c7fd7bdb5b5a2ef8aa9888a82e2ebe9437a"
  license "MIT"
  head "https:github.compsfblack.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?packages.*?black[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b1a782502004ad6bd5dbc0f1991148896978811dab7f0bdc6067e4c2c8b620e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a446d3801a02b904dfe0c3d343c2ac7c47ca2bf94fa808226084abd99f7dac3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af322cc507f7248adcbb024f8415d00f0705753023db60ddfa32de8504b6fbc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0e03d3514a22ffde65b4552d4948e7680e7f423a19ddc1af71773fd6e9aea1e"
    sha256 cellar: :any_skip_relocation, ventura:        "299a02f89c492fa794c710da512256851831ae80aca6f7e0f16959b8cd711a81"
    sha256 cellar: :any_skip_relocation, monterey:       "a72013e10ef95748570af020d7738778fdbed69e6df0b2a874336c3a29a6cbb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f03494eb933fedd7878409c7b36ddb4d54dd94fecf0f5fda7122eec96dcec3"
  end

  depends_on "python-attrs"
  depends_on "python-click"
  depends_on "python-idna"
  depends_on "python-packaging"
  depends_on "python-pathspec"
  depends_on "python-platformdirs"
  depends_on "python@3.12"

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages54079467d3f8dae29b14f423b414d9e67512a76743c5bb7686fb05fe10c9cc3eaiohttp-3.9.1.tar.gz"
    sha256 "8fc49a87ac269d4529da45871e2ffb6874e87779c3d0e2ccd813c0899221239d"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8c1f49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages4a15bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
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