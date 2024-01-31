class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https:black.readthedocs.ioenstable"
  url "https:files.pythonhosted.orgpackages77eca429d15d2e7f996203bff98e2b2e84ad4cb3de318de147b0038dc93fbc71black-24.1.1.tar.gz"
  sha256 "48b5760dcbfe5cf97fd4fba23946681f3a81514c6ab8a45b50da67ac8fbc6c7b"
  license "MIT"
  revision 1
  head "https:github.compsfblack.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?packages.*?black[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e81e2887c58b51c7625b698a526c29451b0a0b4acdf3a32a88f31c990d67a360"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8cef5b27d831850e92e49c1165b04be33a97bc6227730c651515deed0ee1fd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47c3e6b6c02733e8b509e3fa5307071de89eb1365b81b842a934e08b5c1d5483"
    sha256 cellar: :any_skip_relocation, sonoma:         "57e1287bf67b7010d963dd6f1e2f315bbfd0c29b612e530d606beada14a8f105"
    sha256 cellar: :any_skip_relocation, ventura:        "c4f0830f8190dcba2bbae8c0036be1079f9deba89bde5108df129c60eb553640"
    sha256 cellar: :any_skip_relocation, monterey:       "96633b67b861b266708ee76620716aa455806d99b4c3b57952fe17c69f6ab1a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b5e255870253c43fad182d0a3293fa5cadc94e378989102155e030c6f2d867a"
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