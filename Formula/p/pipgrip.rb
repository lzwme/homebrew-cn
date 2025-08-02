class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/1e/72/a340c4818729c16bd5fb554bbd8541ccdd2fe54090f31d29b36d2a2dcb6a/pipgrip-0.10.15.tar.gz"
  sha256 "ad7b6b280f757799fc42fcd44190261e0ad71c026bd607021cbd8f95410acc9b"
  license "BSD-3-Clause"
  head "https://github.com/ddelange/pipgrip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16cf6767fecc4a1ff29bc8c2420e7d758c2ec2729f5855ec219cbe225e57e096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16cf6767fecc4a1ff29bc8c2420e7d758c2ec2729f5855ec219cbe225e57e096"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16cf6767fecc4a1ff29bc8c2420e7d758c2ec2729f5855ec219cbe225e57e096"
    sha256 cellar: :any_skip_relocation, sonoma:        "8812dc956732e605508873e8031aa1649307889dce64024504ef6a9cf1c83749"
    sha256 cellar: :any_skip_relocation, ventura:       "8812dc956732e605508873e8031aa1649307889dce64024504ef6a9cf1c83749"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ca7091e7f0ab3ec30f77410d59e2e3a0474ccb7b2a2122b88b1a0277002d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1ca7091e7f0ab3ec30f77410d59e2e3a0474ccb7b2a2122b88b1a0277002d7d"
  end

  depends_on "python@3.13"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shell_parameter_format: :click)
  end

  test do
    assert_match "pip==25.0.1", shell_output("#{bin}/pipgrip --no-cache-dir pip==25.0.1")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip --no-cache-dir dxpy==0.394.0")
  end
end