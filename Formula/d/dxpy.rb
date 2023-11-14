class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/f2/98/473acbfece859ba22467ec5e5ebb4f07f5b7c230b18dd1151cb0f402b824/dxpy-0.364.0.tar.gz"
  sha256 "1c3c18281261e4e3ce8566f44d61f017c3e9231a848940ba99ff2827a4f0fc06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "877a58362404fc2f22e8c32d938a8758458529e7e27e4207c23cbce9e2399179"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74222153db7e31e7b32552f5c38ccc1f40cfefda45be8647b85862bf2a917963"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d35c7d8c16ab65b6e39e5e2e0133ef80af2060b2f40741829c04c044eca88b23"
    sha256 cellar: :any_skip_relocation, sonoma:         "7665e2d6a05c2e7720fca59a1f8ee00faba5b6033e2ed8eb1299fe5d0c60cdca"
    sha256 cellar: :any_skip_relocation, ventura:        "1ea022eb06a3c15fd9a4cf3480cf856584beab0a64a1511c5bcb0caccbdd8ede"
    sha256 cellar: :any_skip_relocation, monterey:       "b7e9e2d8433f934eb6e0dc56ff8cde420690929fc0e3998fb557488757824ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1233664b6efd1502acf11ed14ee5b6cd5bf6e2c08d31e3b74306b752abb1bca8"
  end

  depends_on "cffi"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-psutil"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/35/d4/14e446a82bc9172d088ebd81c0b02c5ca8481bfeecb13c9ef07998f9249b/websocket_client-0.54.0.tar.gz"
    sha256 "e51562c91ddb8148e791f0155fdb01325d99bb52c4cdbb291aee7a3563fd0849"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end