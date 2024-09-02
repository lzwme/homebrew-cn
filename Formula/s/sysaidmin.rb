class Sysaidmin < Formula
  include Language::Python::Virtualenv

  desc "GPT-powered sysadmin"
  homepage "https:github.comskorokithakissysaidmin"
  url "https:files.pythonhosted.orgpackages59014f961856c3cfb32136782b119b3944466df81fb542dc6c214dc3386245f0sysaidmin-0.2.2.tar.gz"
  sha256 "1bb2b343a0dffb9282e9a2ebddbb825e416b1cc0e9821ed25ded756c86362f47"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8eb9eb431fbe90eb2bafbed0bc7d2dc2ab4936255e709e473a44191f53008c59"
    sha256 cellar: :any,                 arm64_ventura:  "42664483aa393e80588ee038b72cead653acd91e2116daafbf1a38e372f69cef"
    sha256 cellar: :any,                 arm64_monterey: "d976a03b014eab9f6d2610ac862647d11b0f2544d4e92c352cc63d34f1dcffb9"
    sha256 cellar: :any,                 sonoma:         "ed90a63d485043714dc7d5b869efa3dd68ee529c1e521c9e2d5285fe452071fc"
    sha256 cellar: :any,                 ventura:        "155b9399f2381f30e10a4f3ef50c7e10882ee358bc4dc60d1985e47e13bef3b0"
    sha256 cellar: :any,                 monterey:       "60f36c6475388bcb8a9a46be1e8efcf7197a348c379374f948a89c6d76d5dc43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bc21d6392281c7ac9458e93570dcc73bff1ade5d029d2869cac98fd722923ed"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagese6e3c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages17b05e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages788208f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "jiter" do
    url "https:files.pythonhosted.orgpackagesd71aaa64be757afc614484b370a4d9fc1747dc9237b37ce464f7f9d9ca2a3d38jiter-0.5.0.tar.gz"
    sha256 "1d916ba875bcab5c5f7d927df998c4cb694d27dceddf3392e58beaf10563368a"
  end

  resource "openai" do
    url "https:files.pythonhosted.orgpackages41809390645de4e76bf8195073f23029a9b54cd13b4294e3a5bcb56e4df1aafcopenai-1.43.0.tar.gz"
    sha256 "e607aff9fc3e28eade107e5edd8ca95a910a4b12589336d3cbb6bfe2ac306b3c"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages8c99d0a5dca411e0a017762258013ba9905cd6e7baa9a3fd1fe8b6529472902epydantic-2.8.2.tar.gz"
    sha256 "6f62c13d067b0755ad1c21a34bdd06c0c12625a22b0fc09c6b149816604f7c2a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages12e30d5ad91211dba310f7ded335f4dad871172b9cc9ce204f5a56d76ccd6247pydantic_core-2.20.1.tar.gz"
    sha256 "26ca695eeee5f9f1aeeb211ffc12f10bcb6f71e2989988fda61dabd65db878d4"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages58836ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    # $ sysaidmin "The foo process is emailing me and I don't know why."
    output = shell_output("#{bin}sysaidmin 'The foo process is emailing me and I dont know why.' 2>&1", 1)
    assert_match "Incorrect API key provided", output

    assert_match version.to_s, shell_output(bin"sysaidmin --version")
  end
end