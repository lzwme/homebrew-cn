class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https:github.com10genmongo-orchestration"
  url "https:files.pythonhosted.orgpackagesf1c63ccc6baa1693168052dff0a96450ac64ea738249c96d890c12c48e4b76a6mongo_orchestration-0.9.0.tar.gz"
  sha256 "fcf3b644d946794218672f94ea63cea4de1d7a3c29c60bacae507bb64c147134"
  license "Apache-2.0"
  head "https:github.com10genmongo-orchestration.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a06f430a1bfe98a3db9154196efbf63781a6460d67f4a4bfa1c705bd38de3ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b88b974ba368665cd5dff81b484bae16c676e24dcbdba942d9d6abea873d6f18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "722e5b5bd436f03b660ba942328de1521d0409e5b7e99f09f6d855ea769ddaf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "eac1286eb3765e6e53b6a952ec11c85b03520ca246af9c2e00e0c445bf2af9e8"
    sha256 cellar: :any_skip_relocation, ventura:        "d8fd21eb51660afbea787fd0c5ffe39e4101f71fde35975da55088695e3b2389"
    sha256 cellar: :any_skip_relocation, monterey:       "d74f0a7dffa6294dd2f9fb1d0b78acbe3d52b566efd3ae5c1aa8cff27cd4cdad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39bd0bbf9c985eb565e4e23eb74c26211241603f8263e0f41a66686c980b6b45"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "bottle" do
    url "https:files.pythonhosted.orgpackagesfd041c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cheroot" do
    url "https:files.pythonhosted.orgpackages63e2f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackages03b16ca3c2052e584e9908a2c146f00378939b3c51b839304ab8ef4de067f042jaraco_functools-4.0.2.tar.gz"
    sha256 "3460c74cd0d32bf82b9576bbb3527c4364d5b27a21f5158a62aed6c4b42e23f5"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages920dad6a82320cb8eba710fd0dceb0f678d5a1b58d67d03ae5be14874baa39e0more-itertools-10.4.0.tar.gz"
    sha256 "fe0e63c4ab068eac62410ab05cccca2dc71ec44ba8ef29916a0090df061cf923"
  end

  resource "pymongo" do
    url "https:files.pythonhosted.orgpackages052cad0896cb94668c3cad1eb702ab60ae17036b051f54cfe547f11a0322f1d3pymongo-4.8.0.tar.gz"
    sha256 "454f2295875744dc70f1881e4b2eb99cdad008a33574bc8aaf120530f66c0cde"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system bin"mongo-orchestration", "-h"
  end
end