class Touca < Formula
  include Language::Python::Virtualenv
  desc "Open source tool for regression testing complex software workflows"
  homepage "https://github.com/trytouca/trytouca/tree/main/sdk/python"
  url "https://files.pythonhosted.org/packages/c8/6d/e1986d8c9b4f6cd2b583d0df8bd1769989b5ce5cb91dcc613b0d187e4a7a/touca-1.8.7.tar.gz"
  sha256 "244a52be4cf4670077fda0b740ac067470745da7084c241bc619b332f771d940"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de3ec73f50c358aeb0ef87b232c35da8c77ed7370b066bf25fc07e8df761b245"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "938d41e6c293cfa07bc7131b852b7e004c49805da282c0aca37452a94b1bf9b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bd1b8afc3c213d9d52c00f780c2bd0268d28f5d9df02ee95415f7102469f64f"
    sha256 cellar: :any_skip_relocation, ventura:        "5ea0f2322121d96ad68e7c9eede817a14e3ccf6badc8eb9f13affe34c42142c6"
    sha256 cellar: :any_skip_relocation, monterey:       "0a8f77793518fa3f6e23b8ae9633e293e948415035c9d46846f7ca725a209e69"
    sha256 cellar: :any_skip_relocation, big_sur:        "a61e432c44799fa7c00c3a861dfbb01444608fde7724c5bc03542cdc5bbd5967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5114d7af819f141ddeac8e77f804cc294735d20dde38cff2953a0e0dd15456a8"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "flatbuffers" do
    url "https://files.pythonhosted.org/packages/0d/0a/2e88943de46df2d69a037427099323a973489d4697058043e99ace188f3b/flatbuffers-23.1.21.tar.gz"
    sha256 "a948913bbb5d83c43a1193d7943c90e6c0ab732e7f2983111104250aeb61ff85"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "touca-fbs" do
    url "https://files.pythonhosted.org/packages/0e/ae/c5bd348bf8c21d5696538261dc8c05fc5e5a7d60056ecf7180c590d02bd1/touca_fbs-0.0.3.tar.gz"
    sha256 "f9d31d0498bff34637356dcd567ae026e9f10d24ee806bf2e020be49b472779d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/touca version")
    assert_empty shell_output("#{bin}/touca profile set test-profile")
    assert_empty shell_output("#{bin}/touca config set some-key=some-value")
    assert_match "some-key", shell_output("#{bin}/touca config show")
    assert_match "some-value", shell_output("#{bin}/touca config show")
    assert_match "test-profile", shell_output("#{bin}/touca profile ls")
    assert_empty shell_output("#{bin}/touca profile rm test-profile")
  end
end