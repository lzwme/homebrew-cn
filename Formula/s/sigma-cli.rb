class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/68/0b/15ac402f81a252baf60040ede4704983e37301011c62d487741b6a7cb3cd/sigma_cli-2.0.1.tar.gz"
  sha256 "b507993dd6418bd2a0b5a9efac27101c75d0f90ccae59c604e771a5d55bc5375"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d5c195c8c301af891174bd060e1c430d5ed676c7b69172161fb4b8ff4910cbb"
    sha256 cellar: :any,                 arm64_sequoia: "095695825d5b247ef1ae6045c1a0edf810d74848c41a53855dc2426993374b99"
    sha256 cellar: :any,                 arm64_sonoma:  "4a5d3661784da0fbd29e03fbab8c8efbd02f82a0d08bd84a727a6521d0289012"
    sha256 cellar: :any,                 sonoma:        "171bb6b686f57c0701a8173eea4ca207b332c96b33432cb3bed9b5f62e00719e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f0c43fbc626d4adfb0d3b6730413bd3f4c1960e1594c47a3e60c3930bca958f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7609cd0aa5fbfdf98e66a8ee3aa4dfef00be8073c8ac8aa5289867f5c67a754"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  conflicts_with "open-simh", because: "both install `sigma` binaries"

  # TODO: Add back `pysigma-backend-sqlite` when compatabible with sigma_cli>=2
  # https://github.com/SigmaHQ/pySigma-backend-sqlite/blob/main/pyproject.toml#L18
  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "diskcache-stubs" do
    url "https://files.pythonhosted.org/packages/cb/d6/b741a916707520349a3853a3f436aaf5df6e06a2c1499636072b1b3ce45d/diskcache_stubs-5.6.3.6.20240818.tar.gz"
    sha256 "b6eb43899e906b3167a20ac09a9a226f30267a306a96542ea720ebbfc3282796"
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

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/79/45/b0847d88d6cfeb4413566738c8bbf1e1995fad3d42515327ff32cc1eb578/prettytable-3.17.0.tar.gz"
    sha256 "59f2590776527f3c9e8cf9fe7b66dd215837cca96a9c39567414cbc632e8ddb0"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pysigma" do
    url "https://files.pythonhosted.org/packages/a5/4e/7c8ee69872c85f328be10a96bb3de3733142b6bf8577d93ac6b8fa5a927d/pysigma-1.2.0.tar.gz"
    sha256 "1a7a607d12f036c93ba9697b3f328ed3559627d252386ce8cff079a7492582dd"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "types-pyyaml" do
    url "https://files.pythonhosted.org/packages/7e/69/3c51b36d04da19b92f9e815be12753125bd8bc247ba0470a982e6979e71c/types_pyyaml-6.0.12.20250915.tar.gz"
    sha256 "0f8b54a528c303f0e6f7165687dd33fafa81c807fcac23f632b63aa624ced1d3"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sigma", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigma version")

    output = shell_output("#{bin}/sigma plugin list")
    assert_match "SQLite and Zircolite backend", output

    # Only show compatible plugins
    output = shell_output("#{bin}/sigma plugin list --compatible")
    refute_match "IBM QRadar backend", output
  end
end