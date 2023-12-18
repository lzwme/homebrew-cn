class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "Identify anything: emails, IP addresses, and more"
  homepage "https:github.combee-sanpyWhat"
  url "https:files.pythonhosted.orgpackagesae3157bb23df3d3474c1e0a0ae207f8571e763018fa064823310a76758eaef81pywhat-5.1.0.tar.gz"
  sha256 "8a6f2b3060f5ce9808802b9ca3eaf91e19c932e4eaa03a4c2e5255d0baad85c4"
  license "MIT"
  revision 1
  head "https:github.combee-sanpyWhat.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d80030ca434f682f0674b67431f4d4f416d58e8123dbfa93023ad54cf8bd47e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc449a5315cb873b3860d5a0eefa667581713637d6f2a258e2624316f4fbe088"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5e6e74daf24fd21cbe3db1d5f6e483b83fad84b33df8d769d67a0c164e77b9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "231b23c2f713289646ef38bd66e8e8a4fc4f308413d5342de4c0af843c3f1f94"
    sha256 cellar: :any_skip_relocation, ventura:        "711a1879e91b79c56ecba529b4241de462ac29750137d542c37441c8a949f6d7"
    sha256 cellar: :any_skip_relocation, monterey:       "7af641ae14ce814349ed0398ebfd58d8a9ac805e9aabce408316ec65694362b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1befb624408aeaf942bbd525ba31255607bda2b1695b4601af0e3a35ff9db55"
  end

  depends_on "pygments"
  depends_on "python-click"
  depends_on "python@3.12"

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "commonmark" do
    url "https:files.pythonhosted.orgpackages6048a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackages74c3e55ebdd66540503cee29cd3bb18a90bcfd5587a0cf3680173c368be56093rich-10.16.2.tar.gz"
    sha256 "720974689960e06c2efdb54327f8bf0cdbdf4eae4ad73b6c94213cad405c371b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}pywhat 127.0.0.1").strip
  end
end