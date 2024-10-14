class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https:github.commiracle2ktarsnapper"
  url "https:files.pythonhosted.orgpackages4ec50a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fetarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 7
    sha256 cellar: :any,                 arm64_sequoia: "a3f3c24d9015ea8c6e555746211e7af56deb8ce020c047776cd06166f70c77d2"
    sha256 cellar: :any,                 arm64_sonoma:  "feef9a3a01ccc2d8f7e5c7ed0ae91a68c60e0d23e0a80c79a92cd52898e7cb33"
    sha256 cellar: :any,                 arm64_ventura: "4e2dabbd85a18274fc49ff1fbb31c21c6f4e020d796d0630a67d3a404774a715"
    sha256 cellar: :any,                 sonoma:        "553bf81ba1e5331ec8dbc1c0d26bfcc023882d7c71e9815b513623ac330ffece"
    sha256 cellar: :any,                 ventura:       "cf90d02ba37a6bd37df704e14912f700cdd9d2e5c5c107979240bf2a46c8c791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e2d180f17f2f51cfd069e23eed736bd4ddbc71e930b83e66b2d6c1efb66456"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tarsnap"

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  # Drop unneeded argparse requirement: https:github.commiracle2ktarsnapperpull72
  patch do
    url "https:github.commiracle2ktarsnappercommitdef72ae8499b38ab4726d826d7363490de6564fb.patch?full_index=1"
    sha256 "927ff17243b2e751afc7034b059365ca0373db74dcc8d917b8489058a66b2d1c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: tarsnapper", shell_output("#{bin}tarsnapper --help")
  end
end