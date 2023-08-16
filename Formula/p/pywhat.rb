class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "Identify anything: emails, IP addresses, and more"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/ae/31/57bb23df3d3474c1e0a0ae207f8571e763018fa064823310a76758eaef81/pywhat-5.1.0.tar.gz"
  sha256 "8a6f2b3060f5ce9808802b9ca3eaf91e19c932e4eaa03a4c2e5255d0baad85c4"
  license "MIT"
  revision 1
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4968c7ff6c37272afedb526e8bd71aa04c4cfe9539bb095082d65980680ab9c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf27dd5fcbee4898510b45c5aa86297d46e3a53448dbea1f330113a64526cca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afc7dcf4f11bef07bc6d06c2195e9ac9acf641ea8a9455e586ee90a20be11b5a"
    sha256 cellar: :any_skip_relocation, ventura:        "d24dfb3b8b8bb78a470907caf5a7014af1581bb796c0fec704bf73454735cd15"
    sha256 cellar: :any_skip_relocation, monterey:       "33ae9b4c199197f328f6141e5900d946ab6d85712266b86200208372698bdf14"
    sha256 cellar: :any_skip_relocation, big_sur:        "c16b928e2087cf586005ac5f7ea5671c44d69521317b0b8db9f367581c87a5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f453b0de5fc318d9383a4afef920a6d3b989973b60a56be616e37f51827b2332"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/74/c3/e55ebdd66540503cee29cd3bb18a90bcfd5587a0cf3680173c368be56093/rich-10.16.2.tar.gz"
    sha256 "720974689960e06c2efdb54327f8bf0cdbdf4eae4ad73b6c94213cad405c371b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end