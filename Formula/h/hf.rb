class Hf < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/guides/cli"
  url "https://files.pythonhosted.org/packages/3e/9b/ddf3d02a8681f1b9ce52fda03d755dad6b74c4f8172304c4c8d2975450f9/huggingface_hub-1.27.0.tar.gz"
  sha256 "c1fed40ea82a6b41b477f5243546549b792ae0a93abcea608cff66089bf8f8df"
  license "Apache-2.0"
  head "https://github.com/huggingface/huggingface_hub.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e9476b1c0916bf8a8a86f538085b191322c1ebf3cf09d5cdae0a6dfda0f5a5db"
    sha256 cellar: :any, arm64_sequoia: "562667adfb8012316f5923db182f22c457287506f189a61d79ffc35a55d91b71"
    sha256 cellar: :any, arm64_sonoma:  "8fe628b8d76be60856eee76be306dda0ccc452fabf2865b5f831161f2a10d667"
    sha256 cellar: :any, sonoma:        "9d796880e3273b2ad53e88c1551bda095ec5a2cf1a839fcaf9a185227fb352f2"
    sha256 cellar: :any, arm64_linux:   "f506f3d9549582de6208a884867a0cd1fcc3f0108924de5e98bd3ac67eef9d45"
    sha256 cellar: :any, x86_64_linux:  "e4a967a6d35672d5881c38e78d85d3de02343881cf39ec4da5cfea08c5b49d03"
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
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f6/57/3ba6e6cb097f85b855b00163d169f35365f44277df044dcf96d55b8f62a3/filelock-3.32.2.tar.gz"
    sha256 "c33351e1f49cae33414acbc6d56784e6ecee82514ec90795da1161fc4836b5b8"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/00/78/f34251dadb8f3921264a1d9b8946f5e542014ee2614b285261b4e40e6775/fsspec-2026.7.0.tar.gz"
    sha256 "c803c40f4cf860b49dea58ee3e1c33cb9c790520e233537e1340049f89b82a88"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/1b/ab/522a2ab67f27971a9d48ca666d4fca85ef7d5282d142e31fd087e27b1bbe/hf_xet-1.6.0.tar.gz"
    sha256 "2e58454a340b3556dfa4972d5451aff4fba8dd42a236600ba1a1d2b1514f0fef"
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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      # Use native-tls instead since building bundled aws-lc is tricky to do indirectly within superenv.
      # Can consider switching if system copy is supported https://github.com/aws/aws-lc-rs/issues/936
      inreplace %w[xet_client/Cargo.toml xet_data/Cargo.toml xet_pkg/Cargo.toml],
                'default = ["rustls-tls"]', 'default = ["native-tls"]'

      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"hf", shell_parameter_format: :click)
  end

  test do
    ENV["HUGGINGFACE_HUB_CACHE"] = testpath
    ENV["NO_COLOR"] = "1"
    assert_match "Not logged in", shell_output("#{bin}/hf auth whoami 2>&1", 1)
    assert_match "No results found.", shell_output("#{bin}/hf cache ls")
  end
end