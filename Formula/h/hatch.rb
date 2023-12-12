class Hatch < Formula
  include Language::Python::Virtualenv

  desc "Modern, extensible Python project management"
  homepage "https://hatch.pypa.io/latest/"
  url "https://files.pythonhosted.org/packages/19/a2/53530f20f27bc9a3db11dce22d8d8a441c36bb92c171b317323005b9f5aa/hatch-1.8.0.tar.gz"
  sha256 "ab2b90888111b12d8baf0b7de3c99c5705f693858a0f76a51b872ed265a9785f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f00afcc6f39996310a4b039e664474a0dc482baa2ab02edfb0d3e047847e44d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68d609ab9620312d7312c5dab1bb9275401f57c61c6712629eda51d78456a801"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bac93256dd6ebe5f95c784000f5b56fe8969304b83aa73b01783f5c3d8e1cf3"
    sha256 cellar: :any_skip_relocation, sonoma:         "95f1364dcf03e376c58f63897a7ebb345eaf11c9329805820cd8725b5b1ce03b"
    sha256 cellar: :any_skip_relocation, ventura:        "193b20f9e1e0b57541d83643ee7e6d1893513d5afa460e3a0b163e55834bcab8"
    sha256 cellar: :any_skip_relocation, monterey:       "525d4d6ca2e7de986d283167bae766609bd093d09d76d4fb752258e0fb069f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c705010c5e0270c7c368542ff3a9d8514ebe31d4539cfd28da44f5ba2c4d26ef"
  end

  depends_on "keyring"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-filelock"
  depends_on "python-hatchling"
  depends_on "python@3.12"
  depends_on "virtualenv"

  on_linux do
    depends_on "cffi"
    depends_on "pycparser"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/6e/57/075e07fb01ae2b740289ec9daec670f60c06f62d04b23a68077fd5d73fab/anyio-4.1.0.tar.gz"
    sha256 "5a0bec7085176715be77df87fc66d6c9d70626bd752fcc85f57cdbee5b3760da"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/18/56/78a38490b834fa0942cbe6d39bd8a7fd76316e8940319305a98d2b320366/httpcore-1.0.2.tar.gz"
    sha256 "9fc092e4799b26174648e54b74ed5f683132a464e95643b226e00c2ed2fa6535"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/8c/23/911d93a022979d3ea295f659fbe7edb07b3f4561a477e83b3a6d0e0c914e/httpx-0.25.2.tar.gz"
    sha256 "8b8fcaa0c8ea7b05edd69a094e63a2094c4efcb48129fb757361bc423c0ad9e8"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/4d/13/b8c47191994abd86cbdb256146dbd7bbabcaaa991984b720f68ccc857bfc/userpath-1.9.1.tar.gz"
    sha256 "ce8176728d98c914b6401781bf3b23fccd968d1647539c8788c7010375e02796"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/5d/91/2162ab4239b3bd6743e8e407bc2442fca0d326e2d77b3f4a88d90ad5a1fa/zstandard-0.22.0.tar.gz"
    sha256 "8226a33c542bcb54cd6bd0a366067b610b41713b64c9abec1bc4533d69f51e70"
  end

  def install
    virtualenv_install_with_resources

    # install a `.pth` file to link separate formulae
    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[keyring virtualenv].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    generate_completions_from_executable(bin/"hatch", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    ENV["HATCH_PYTHON"] = "self"
    system bin/"hatch", "new", "homebrew"
    assert_predicate testpath/"homebrew/pyproject.toml", :exist?

    cd testpath/"homebrew" do
      inreplace "pyproject.toml", "dependencies = []", "dependencies = ['requests==2.31.0']"
      system bin/"hatch", "config", "set", "dirs.env.virtual", ".venv"
      system bin/"hatch", "env", "create"
      output = shell_output("#{bin}/hatch env run -- python -c 'import requests;print(requests.__version__)'")
      assert_equal "2.31.0", output.strip.lines.last
    end
  end
end