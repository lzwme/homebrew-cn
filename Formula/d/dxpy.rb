class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/7d/6a/24de43eace08ff1512c658591466115949ae1bd8fed22e841f6e12f405de/dxpy-0.365.0.tar.gz"
  sha256 "234efe289c71da5069cb7e42f569c9dbff922e270267365d8b36798fd541240c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55601443c4c903803a06cb9f658dc585c0ab163f84055d36c2b149fc4347ff84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b78a3dba5d6fe68281a3101f05295e61dbee69bec56825825e26fcb7810e7ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dff2ff7f4719a70dd72a8b9c0cdc8ce6dff5c9e0ad51e075f4f43eab159bfe68"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c835ef1784e1b6379ce8aed3803ef191f7304fdcd1a65f319253865ba4c6b7b"
    sha256 cellar: :any_skip_relocation, ventura:        "400fc3e592d8086d0989a44ff5e75fa6463c9dbc0d4240f708cfab657ae5a736"
    sha256 cellar: :any_skip_relocation, monterey:       "314010187c4ba17ac71868bb41e74987cb13e96d766216730b3b7cf4e62c4460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "535e5c63c4e231b8246298ef6965f47f5646e99dcb99306630d46addefa8bde9"
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