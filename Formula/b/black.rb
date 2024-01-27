class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https:black.readthedocs.ioenstable"
  url "https:files.pythonhosted.orgpackagesea1933d4f2f0babcbc07d3e2c058a64c76606cf19884a600536c837aaf4e4f2dblack-24.1.0.tar.gz"
  sha256 "30fbf768cd4f4576598b1db0202413fafea9a227ef808d1a12230c643cefe9fc"
  license "MIT"
  head "https:github.compsfblack.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?packages.*?black[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fc58032cc4af2ad56da042389b37d4b263f8f42dd938ebb91b24860ebc352f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2759ab907d60a125abaf67525c36f562b7453a5806c9de10049418ae5b4419b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e1556cc96c3333b4bd760540681c55ef010ca4044dbc327a17ad30f9aa85437"
    sha256 cellar: :any_skip_relocation, sonoma:         "be1c66a65ccbad77fbf4b46f7570d3e53dccb68bc80f05c026ffa35519e66952"
    sha256 cellar: :any_skip_relocation, ventura:        "2aa40f90de0b69d83db7ceb418f3ac213e55667569cff62ff345b56183c8e319"
    sha256 cellar: :any_skip_relocation, monterey:       "e30c3d85bd8e3e9cb2a87b4b50030cfa674bebe9029aa833b3fdd4c8fd3a57f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b566cec7ef93aa894a09e27e1c40356598a119afc3a5f78529a72131c6452b2"
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