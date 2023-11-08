class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/47/98/87dfab0ae5d1abad48a56825585dcd406cdc183dbce930e24ef8439769ba/mackup-0.8.40.tar.gz"
  sha256 "d267c38719679d4bd162d7f0d0743a51b4da98a5d454d3ec7bb2f3f22e6cadaf"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d798f8600805537a50c7c4978540e3c9e7bfb26c29b362e3073d040558f9d20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c81d9094937e2cae115cb461396e48fa04a4b05758fcd468499be25e2f8776e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6adc28de1433fec1957fc6af1b4343fc84bd238eedef86d326ed397d8a267fa3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f49986ffac75dd6c863e5bc38383e6beb3d4cf995e95d869f48cdd236dabec36"
    sha256 cellar: :any_skip_relocation, ventura:        "a76a015a0c57953e8848181794f28f0d784fc7341beed637d90d3d3629d645c3"
    sha256 cellar: :any_skip_relocation, monterey:       "fe91f6cae5258fe6830fc5c5513946723c39a946ecffcdaa3e246bdc40b4302d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b9660c5181fc347de2f8f0d8fbfcdb06e97e3d564e4c5e7e0b27700092a376c"
  end

  depends_on "python-docopt"
  depends_on "python@3.12"
  depends_on "six"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end