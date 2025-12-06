class Forbidden < Formula
  include Language::Python::Virtualenv

  desc "Bypass 4xx HTTP response status codes and more"
  homepage "https://github.com/ivan-sincek/forbidden"
  url "https://files.pythonhosted.org/packages/9b/aa/98fc3ee28aac41cae341a197858ff6af5d79e40dcd45c8a6e37b1fdbfd19/forbidden-13.4.tar.gz"
  sha256 "dc987150b71515810d7ae252895b3ca6e077a8d9b3cbb0d09dfc9797c933a14d"
  license "MIT"
  revision 1
  head "https://github.com/ivan-sincek/forbidden.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c6d488eb6055c9606a835b9661bec7e1faf09b4ea43818f6663133f5fff98e3"
    sha256 cellar: :any,                 arm64_sequoia: "15b494d89c92b5bd84b8a06a0448755d157bd08f64f9c15a76fcbbea0a6f61d6"
    sha256 cellar: :any,                 arm64_sonoma:  "3887645875e461c7862f9795999f4c89f9b5536a11c6b15ad0aad3d103ef80af"
    sha256 cellar: :any,                 sonoma:        "d4931013eca439d88c25cce11461acb42a6c40fae7ec9085df57afdcf3b60ac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4945b03d1f311af15548be05b0064b0b7540332d2df07d4a315115dd8fb96fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a35892523804707604ff6676f9622c74e1d1ee477db6397c496cf6f3af5e810d"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pycparser" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cffi cryptography pycparser]

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/9a/26/d43128764a6f8fe1668c4f87aba6b1fe52bea81d05a35c84a70d3c70b6f7/alive-progress-3.3.0.tar.gz"
    sha256 "457dd2428b48dacd49854022a46448d236a48f1b7277874071c39395307e830c"
  end

  resource "bot-safe-agents" do
    url "https://files.pythonhosted.org/packages/44/8e/fd72545a981a5133b51802852bdb6d5a313a330b61cec952b3455456b9fd/bot_safe_agents-1.1.tar.gz"
    sha256 "ba3405bc92de1301fdd19b48e80ba7f26a8661ebbba2ab010e80e15267075ba6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "graphemeu" do
    url "https://files.pythonhosted.org/packages/76/20/d012f71e7d00e0d5bb25176b9a96c5313d0e30cf947153bfdfa78089f4bb/graphemeu-0.7.2.tar.gz"
    sha256 "42bbe373d7c146160f286cd5f76b1a8ad29172d7333ce10705c5cc282462a4f8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/e3/3d/01255f1cde24401f54bb3727d0e5d3396b67fc04964f287d5d473155f176/pycurl-7.45.7.tar.gz"
    sha256 "9d43013002eab2fd6d0dcc671cd1e9149e2fc1c56d5e796fad94d076d6cb69ef"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/87/56/ab275c2b56a5e2342568838f0d5e3e66a32354adcc159b495e374cda43f5/termcolor-3.2.0.tar.gz"
    sha256 "610e6456feec42c4bcd28934a8c87a06c3fa28b01561d46aa09a9881b8622c58"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/forbidden -u https://brew.sh -t methods -f GET")
    assert_match "\"status\": 200", output
  end
end