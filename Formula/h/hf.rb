class Hf < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/guides/cli"
  url "https://files.pythonhosted.org/packages/e6/7e/fad82ad491b226e832d2da90a1a59f36acd4526cda8c726f639834754aa4/huggingface_hub-1.20.1.tar.gz"
  sha256 "9f6d63bfbeab2d2a8357200a9bc4f18cd2c8bfac9579f792f5922e77bf6471d0"
  license "Apache-2.0"
  head "https://github.com/huggingface/huggingface_hub.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "13dab666fc7bd501fe19ff3f07a0614fa3ddf15ace85b0af3674f1575dc7b481"
    sha256 cellar: :any, arm64_sequoia: "08eb8778a166ac380c0ce9ed0dd2353a073f4cac9c07d22e27949fd0f7f6b123"
    sha256 cellar: :any, arm64_sonoma:  "d4d40f5489b640a657bf75580c3d919c246652f8ef9c6ce69aab4e89bcc403dd"
    sha256 cellar: :any, sonoma:        "2e22e3139d52bb77af7bc435d5a8db387a892c5a44b23ddbedc287b27b489d4d"
    sha256 cellar: :any, arm64_linux:   "b0e25663a54b03cdd584d8b2aa803fcbe953fd7c845d4a795bad5ee82136fe5b"
    sha256 cellar: :any, x86_64_linux:  "7f0fc49443580e2cd1a63bcfad374379bad493468c249ea971802e555b227008"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for `hf-xet`

  depends_on "certifi" => :no_linkage
  depends_on "git-lfs"
  depends_on "libyaml"
  depends_on "python@3.14"

  on_linux do
    depends_on "openssl@3"
  end

  pypi_packages package_name:     "huggingface_hub[cli]",
                exclude_packages: "certifi"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/1c/b5/001890774a9552aff22502b8da382593109ce0c95314abaebbb116567545/anyio-4.14.0.tar.gz"
    sha256 "b47c1f9ccf73e67021df785332508f99379c68fa7d0684e8e3492cb1d4b23f89"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/dc/be6cbe99670cd6e4ad387123647cb08e0c32975e223f82551e914c5568a6/filelock-3.29.4.tar.gz"
    sha256 "10cdb3656fc44541cdf30652a93fb10ec6b05325620eb316bd26893e4201538a"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/10/a1/ae4e3e5003468d6391d2c77b6fa1cd73bd5d13511d81c642d7b28ac90ed4/fsspec-2026.6.0.tar.gz"
    sha256 "f5bac145310fe30e16e1471bd6840b2d990d609e872251d7e674241822abf01a"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/4b/2d/57fd21d84d93efb4bd0b962383790e19dd1bc053501b4264c97903b4e83e/hf_xet-1.5.1.tar.gz"
    sha256 "51ef4500dab3764b41135ee1381a4b62ce56fc54d4c92b719b59e597d6df5bf6"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/87/d7/0535a28b1f5f24f6612fb3ff1e89fb1a8d160fee0f976e0aa6803862134b/tqdm-4.68.3.tar.gz"
    sha256 "00dfa48452b6b6cfae3dd9885636c23d3422d1ec97c66d96818cbd5e0821d482"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e4/51/9aed62104cea109b820bbd6c14245af756112017d309da813ef107d42e7e/typer-0.25.1.tar.gz"
    sha256 "9616eb8853a09ffeabab1698952f33c6f29ffdbceb4eaeecf571880e8d7664cc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      # Use native-tls instead since building bundled aws-lc is tricky to do indirectly within superenv.
      # Can consider switching if system copy is supported https://github.com/aws/aws-lc-rs/issues/936
      inreplace "xet_client/Cargo.toml", 'default = ["rustls-tls"]', 'default = ["native-tls"]'

      if ENV.effective_arch == :armv8
        # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto
        inreplace "xet_data/Cargo.toml",
                  'sha2 = { workspace = true, features = ["asm"] }',
                  "sha2 = { workspace = true }"
      end
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"hf", shell_parameter_format: :typer)
  end

  test do
    ENV["HUGGINGFACE_HUB_CACHE"] = testpath
    ENV["NO_COLOR"] = "1"
    assert_match "Not logged in", shell_output("#{bin}/hf auth whoami 2>&1", 1)
    assert_match "No results found.", shell_output("#{bin}/hf cache ls")
  end
end