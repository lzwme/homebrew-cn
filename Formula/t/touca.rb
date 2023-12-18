class Touca < Formula
  include Language::Python::Virtualenv
  desc "Open source tool for regression testing complex software workflows"
  homepage "https:github.comtrytoucatrytoucatreemainsdkpython"
  url "https:files.pythonhosted.orgpackagesc86de1986d8c9b4f6cd2b583d0df8bd1769989b5ce5cb91dcc613b0d187e4a7atouca-1.8.7.tar.gz"
  sha256 "244a52be4cf4670077fda0b740ac067470745da7084c241bc619b332f771d940"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a885219aadafa7a8691d1442b9dcbb0f8b711a2630a45a9254bf2490529650c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12452b5c5d4105d8d4d9e953f95e88446a471127c2741981df374b92377414b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f125890b52bbb83c41da6dcbce56e37730c6b60eb3c91ea8a7ef750c0bae6ebc"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ee394c3708cdbc2aaf49834d8f7d98cdeb594f35ee7141c530bee624dd8d67a"
    sha256 cellar: :any_skip_relocation, ventura:        "b94b3e407073badc2157340226b1a0d3719dac71f11b86523b719a3304343f70"
    sha256 cellar: :any_skip_relocation, monterey:       "a11d5858f280a2c2d64d7b8f9c787a811e1a3e109bd21003290d0871b17fa68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f30224270a4263629886ed84036ff4ab0e7adf48ac95dfd82c1d159e2d2a005"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "commonmark" do
    url "https:files.pythonhosted.orgpackages6048a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "flatbuffers" do
    url "https:files.pythonhosted.orgpackages0c6e3e52cd294d8e7a61e010973cce076a0cb2c6c0dfd4d0b7a13648c1b98329flatbuffers-23.5.26.tar.gz"
    sha256 "9ea1144cac05ce5d86e2859f431c6cd5e66cd9c78c558317c7955fb8d4c78d89"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackages1123814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "touca-fbs" do
    url "https:files.pythonhosted.orgpackages0eaec5bd348bf8c21d5696538261dc8c05fc5e5a7d60056ecf7180c590d02bd1touca_fbs-0.0.3.tar.gz"
    sha256 "f9d31d0498bff34637356dcd567ae026e9f10d24ee806bf2e020be49b472779d"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}touca version")
    assert_empty shell_output("#{bin}touca profile set test-profile")
    assert_empty shell_output("#{bin}touca config set some-key=some-value")
    assert_match "some-key", shell_output("#{bin}touca config show")
    assert_match "some-value", shell_output("#{bin}touca config show")
    assert_match "test-profile", shell_output("#{bin}touca profile ls")
    assert_empty shell_output("#{bin}touca profile rm test-profile")
  end
end