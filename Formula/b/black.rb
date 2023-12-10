class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/ef/21/c2d38c7c98a089fd0f7e1a8be16c07f141ed57339b3082737de90db0ca59/black-23.11.0.tar.gz"
  sha256 "4c68855825ff432d197229846f971bc4d6666ce90492e5b02013bcaca4d9ab05"
  license "MIT"
  revision 1
  head "https://github.com/psf/black.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/black[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52ad060ad2a85a4fc6cc20ceb6c644eeff65847682b5f1eac0521a1fbfe283c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31b0638d860dc5307c53d200650d1e591a7f0e607f0b1c40d1a03c798ffd8dd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2d68837f68b987e9887b6550d16d3833ac3e68681699b705245e478a41a0a18"
    sha256 cellar: :any_skip_relocation, sonoma:         "72dff657ef1505a69073cfd57edfc3016e9f77b18e041c6f5060f3d0bbd3ce20"
    sha256 cellar: :any_skip_relocation, ventura:        "c72329f38fd922d639e0f1947038f910ee990b017fcdfede5d83d2bc3d4d037b"
    sha256 cellar: :any_skip_relocation, monterey:       "298cc65930f9fee3aa48f175b40453b5397e0e6aaafe28dc4588e324f0283f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c25eed4fcd03bd5f558e8afb43358270e7e27faeadd786bdcd126111daf6c84b"
  end

  depends_on "python-attrs"
  depends_on "python-click"
  depends_on "python-idna"
  depends_on "python-packaging"
  depends_on "python-pathspec"
  depends_on "python-platformdirs"
  depends_on "python@3.12"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/71/80/68f3bd93240efd92e9397947301efb76461db48c5ac80be2423ffa9c20a3/aiohttp-3.9.0.tar.gz"
    sha256 "09f23292d29135025e19e8ff4f0a68df078fe4ee013bca0105b2e803989de92d"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"black", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  service do
    run opt_bin/"blackd"
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/blackd.log"
    error_log_path var/"log/blackd.log"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"black_test.py").write <<~EOS
      print(
      'It works!')
    EOS
    system bin/"black", "black_test.py"
    assert_equal "print(\"It works!\")\n", (testpath/"black_test.py").read
    port = free_port
    fork { exec "#{bin}/blackd --bind-host 127.0.0.1 --bind-port #{port}" }
    sleep 10
    assert_match "print(\"valid\")", shell_output("curl -s -XPOST localhost:#{port} -d \"print('valid')\"").strip
  end
end