class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/c4/d9/07b458a3f1c525ac392b5edc6b191ff140b596f9d77092429417a54e249d/black-25.12.0.tar.gz"
  sha256 "8d3dd9cea14bff7ddc0eb243c811cdb1a011ebb4800a5f0335a01a68654796a7"
  license "MIT"
  head "https://github.com/psf/black.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d1577acf6369be0377e0eaa5b487e5375fbc1523ac28f5942d62cd78c8ea281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f14ceb1eaf6de73cf480c24a9993373d7430dc73ec7076546ee5b35da2a02e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d13b4221dda9078d6d11dd48c0c21374447c236bdefdfd7e2116df5492513f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "92cc4d51e309382592505e4f8f52ad94d702d1ab7c20376a373101494dcd3475"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e4f929dc6c3dd647a4ca682d385c64f55c7ffb933b522c2c4f56de1367abb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1165d91c7925e398265d92bec581e2abca646cf0b33030469aad167bb0c1f9ea"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "black[d]"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/1c/ce/3b83ebba6b3207a7135e5fcaba49706f8a4b6008153b4e30540c982fae26/aiohttp-3.13.2.tar.gz"
    sha256 "40176a52c186aefef6eb3cad2cdd30cd06e3afbe88fe8ab2af9c0b90f228daca"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/4e/8d/a762be14dae1c3bf280202ba3172020b2b0b4c537f94427435f19c413b72/pytokens-0.3.0.tar.gz"
    sha256 "2f932b14ed08de5fcf0b391ace2642f858f1394c0857202959000b68ed7a458a"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  def install
    ENV["HATCH_BUILD_HOOK_ENABLE_MYPYC"] = "1"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"black", shell_parameter_format: :click)
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
    assert_match "compiled: yes", shell_output("#{bin}/black --version")

    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"black_test.py").write <<~PYTHON
      print(
      'It works!')
    PYTHON
    system bin/"black", "black_test.py"
    assert_equal 'print("It works!")', (testpath/"black_test.py").read.strip

    port = free_port
    spawn bin/"blackd", "--bind-host=127.0.0.1", "--bind-port=#{port}"
    sleep 10
    output = shell_output("curl -s -XPOST localhost:#{port} -d \"print('valid')\"").strip
    assert_match 'print("valid")', output
  end
end