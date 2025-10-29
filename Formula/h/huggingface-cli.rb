class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/guides/cli"
  url "https://files.pythonhosted.org/packages/f7/e0/308849e8ff9590505815f4a300cb8941a21c5889fb94c955d992539b5bef/huggingface_hub-1.0.1.tar.gz"
  sha256 "87b506d5b45f0d1af58df7cf8bab993ded25d6077c2e959af58444df8b9589f3"
  license "Apache-2.0"
  head "https://github.com/huggingface/huggingface_hub.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc5d11911236b180e2f6e4232a510e9d8c006883414e9b6a8ad73e52ea34d6c8"
    sha256 cellar: :any,                 arm64_sequoia: "a2b3b28c7a5ebb57dba3a7dce2588efa083eb1eb00a62f6c1549f85c31ae1433"
    sha256 cellar: :any,                 arm64_sonoma:  "99205869532d6f3becd9f7ef23c997fb62e27ce005d64aeec355195f44248fc6"
    sha256 cellar: :any,                 sonoma:        "25299361ce5e8d01d0266af09662057ce3bf7d1459c5a395ee67bb4e27215651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f959dc8f218f08c666d1baef964159b0b38c8d61579909acbd1bbb5f6d45d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4ee797024a25412f9f2252e4e5b84d230caf29bc080fdf74bccee6d96f40edf"
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

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/de/e0/bab50af11c2d75c9c4a2a26a5254573c0bd97cea152254401510950486fa/fsspec-2025.9.0.tar.gz"
    sha256 "19fd429483d25d28b65ec68f9f4adc16c17ea2c7c7bf54ec61360d478fb19c19"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/5e/6e/0f11bacf08a67f7fb5ee09740f2ca54163863b07b70d579356e9222ce5d8/hf_xet-1.2.0.tar.gz"
    sha256 "a8c27070ca547293b6890c4bf389f713f80e8c478631432962bb7f4bc0bd7d7f"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typer-slim" do
    url "https://files.pythonhosted.org/packages/8e/45/81b94a52caed434b94da65729c03ad0fb7665fab0f7db9ee54c94e541403/typer_slim-0.20.0.tar.gz"
    sha256 "9fc6607b3c6c20f5c33ea9590cbeb17848667c51feee27d9e314a579ab07d1a3"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      if ENV.effective_arch == :armv8
        # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto
        inreplace "data/Cargo.toml",
                  'sha2 = { workspace = true, features = ["asm"] }',
                  "sha2 = { workspace = true }"
      end
      venv.pip_install Pathname.pwd
    end
  end

  test do
    ENV["HUGGINGFACE_HUB_CACHE"] = testpath
    ENV["NO_COLOR"] = "1"
    assert_match "Not logged in", shell_output("#{bin}/hf auth whoami")
    assert_match "No cached repositories found.", shell_output("#{bin}/hf cache ls")
  end
end