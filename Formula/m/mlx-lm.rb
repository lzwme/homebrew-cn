class MlxLm < Formula
  include Language::Python::Virtualenv

  desc "Run LLMs with MLX"
  homepage "https://github.com/ml-explore/mlx-lm"
  url "https://ghfast.top/https://github.com/ml-explore/mlx-lm/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "637de1ae34e30d845e1369563309997f57a6b1c1d6ce0e542fd5537cf9d253a3"
  license "MIT"
  revision 1
  head "https://github.com/ml-explore/mlx-lm.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "19dd02a3dde2c2b0f3cf4045ba5b16813e83b78423fe59d574f33ed7a4e2fd54"
    sha256 cellar: :any, arm64_sequoia: "dd08a5070af342cad21f6a44a6dcc73cb5a653bad28237c31b1667adf604cc46"
    sha256 cellar: :any, arm64_sonoma:  "0f3527eaf33b9452d3e0e5af3bd3b9715afc2cd8e2a783fbd2ae90bcc2d47026"
    sha256 cellar: :any, sonoma:        "a13ebe0f0e57384354a935e72e7c942d188e1976548adf737c276c305f0d8993"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on :macos
  depends_on macos: :ventura
  depends_on "mlx"
  depends_on "numpy"
  depends_on "python@3.14"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/de/e0/bab50af11c2d75c9c4a2a26a5254573c0bd97cea152254401510950486fa/fsspec-2025.9.0.tar.gz"
    sha256 "19fd429483d25d28b65ec68f9f4adc16c17ea2c7c7bf54ec61360d478fb19c19"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/74/31/feeddfce1748c4a233ec1aa5b7396161c07ae1aa9b7bdbc9a72c3c7dd768/hf_xet-1.1.10.tar.gz"
    sha256 "408aef343800a2102374a883f283ff29068055c111f003ff840733d3b715bb97"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/10/7e/a0a97de7c73671863ca6b3f61fa12518caf35db37825e43d63a70956738c/huggingface_hub-0.35.3.tar.gz"
    sha256 "350932eaa5cc6a4747efae85126ee220e4ef1b54e29d31c3b45c5612ddf0b32a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/fa/a4/cc17347aa2897568beece2e674674359f911d6fe21b0b8d6268cd42727ac/protobuf-6.32.1.tar.gz"
    sha256 "ee2469e4a021474ab9baafea6cd070e5bf27c7d29433504ddea1a4ee5850f68d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/ac/cc/738f3011628920e027a11754d9cae9abec1aed00f7ae860abbf843755233/safetensors-0.6.2.tar.gz"
    sha256 "43ff2aa0e6fa2dc3ea5524ac7ad93a9839256b8703761e76e2d0b2a3fa4f15d9"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/1c/46/fb6854cec3278fbfa4a75b50232c77622bc517ac886156e6afbfa4d8fc6e/tokenizers-0.22.1.tar.gz"
    sha256 "61de6522785310a309b3407bac22d99c4db5dba349935e99e4d15ea2226af2d9"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/f3/5c/a22c39dac2687f3fe2a6b97e2c1ae516e91cd4d3976a7a2b7c24ff2fae48/transformers-4.57.0.tar.gz"
    sha256 "d045753f3d93f9216e693cdb168698dfd2e9d3aad1bb72579a5d60ebf1545a8b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run opt_bin/"mlx_lm.server"
    keep_alive true
    working_dir var
    log_path var/"log/mlx-lm.log"
    error_log_path var/"log/mlx-lm.log"
  end

  test do
    port = free_port
    pid = fork { exec bin/"mlx_lm.server", "--port=#{port}" }
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    begin
      output = JSON.parse shell_output("curl -s localhost:#{port}/health")
      assert_equal "ok", output["status"]
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end