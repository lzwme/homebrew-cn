class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/80/bc/46ec328dcb9abcc8e9956c02378bfd4bfb053cb94fcf40b62b75f900d147/mongo-orchestration-0.8.0.tar.gz"
  sha256 "9cb17a4f1a19d578a04c34ef51f4d5bc2a1c768f4968948792f330644c9398f6"
  license "Apache-2.0"
  revision 3
  head "https://github.com/10gen/mongo-orchestration.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16ff24f456b10c64a551a56cca562cf8858fd3d0cf4c0688b9de2980776f7b9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7594315c9e9082c7cf54edcc4e4a769bef0f9842de6e5be918ceb1a2c681125"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b4c36192107a9e948db2e12b684b47b422db802c1dfd2da5c914945202e2197"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac1a809dc8e2ede1f87c6cdababcdfde1e9b8379209612994a1d35599e677d98"
    sha256 cellar: :any_skip_relocation, ventura:        "bb211a3ce3480761f0d3b185aff582c686020795210d82f87796ca776fb5c556"
    sha256 cellar: :any_skip_relocation, monterey:       "a0fc0ddad4266f8cc48f543f84e659c0e006191f0d929e8181ab9b45edccc737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23b11fc71c58fc7a9f7a49f86a33af3e8953a93e9554f92209834a38e8c2549c"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "six"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/08/7c/95c154177b16077de0fec1b821b0d8b3df2b59c5c7b3575a9c1bf52a437e/cheroot-10.0.0.tar.gz"
    sha256 "59c4a1877fef9969b3c3c080caaaf377e2780919437853fc0d32a9df40b311f0"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/e6/f7/97322b08780ac7f783893991a1ed2a0a8b9c729d06350e2a1c6e7f8687cb/jaraco.functools-3.9.0.tar.gz"
    sha256 "8b137b0feacc17fef4bacee04c011c9e86f2341099c870a1d12d3be37b32a638"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2d/73/3557e45746fcaded71125c0a1c0f87616e8258c78391f0c365bf97bbfc99/more-itertools-10.1.0.tar.gz"
    sha256 "626c369fa0eb37bac0291bce8259b332fd59ac792fa5497b59837309cd5b114a"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/a3/a6/eae874c4b686dd542e9425ba74a3945a0ebe1247e5801f83ab8b13dcfe59/pymongo-4.5.0.tar.gz"
    sha256 "681f252e43b3ef054ca9161635f81b730f4d8cadd28b3f2b2004f5a72f853982"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system "#{bin}/mongo-orchestration", "-h"
  end
end