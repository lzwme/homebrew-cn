class Touca < Formula
  include Language::Python::Virtualenv
  desc "Open source tool for regression testing complex software workflows"
  homepage "https:github.comtrytoucatrytoucatreemainsdkpython"
  url "https:files.pythonhosted.orgpackagesc86de1986d8c9b4f6cd2b583d0df8bd1769989b5ce5cb91dcc613b0d187e4a7atouca-1.8.7.tar.gz"
  sha256 "244a52be4cf4670077fda0b740ac067470745da7084c241bc619b332f771d940"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db63d5f14e5b12b46f6bf83f299fbdaa6c635785979ded9aad35861543f4f4b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db63d5f14e5b12b46f6bf83f299fbdaa6c635785979ded9aad35861543f4f4b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db63d5f14e5b12b46f6bf83f299fbdaa6c635785979ded9aad35861543f4f4b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b45015272a5d8987cd49b5e672f6a4fe382d4dda1d8b893b474952d542e4fe9"
    sha256 cellar: :any_skip_relocation, ventura:        "6b45015272a5d8987cd49b5e672f6a4fe382d4dda1d8b893b474952d542e4fe9"
    sha256 cellar: :any_skip_relocation, monterey:       "8572f59ccea2d9d4f3aca0de8e6b103d5d2e407ca5c83cb080e09ba81cdcdb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eac5cb706608b3c375dd16029960ac67701c55ea254cd5bf8fdeeb19cc8b134"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "commonmark" do
    url "https:files.pythonhosted.orgpackages6048a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "flatbuffers" do
    url "https:files.pythonhosted.orgpackages0c6e3e52cd294d8e7a61e010973cce076a0cb2c6c0dfd4d0b7a13648c1b98329flatbuffers-23.5.26.tar.gz"
    sha256 "9ea1144cac05ce5d86e2859f431c6cd5e66cd9c78c558317c7955fb8d4c78d89"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
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
    url "https:files.pythonhosted.orgpackagesc89365e479b023bbc46dab3e092bda6b0005424ea3217d711964ccdede3f9b1burllib3-1.26.19.tar.gz"
    sha256 "3e3d753a8618b86d7de333b4223005f68720bcd6a7d2bcb9fbd2229ec7c1e429"
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