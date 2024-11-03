class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https:xon.sh"
  url "https:files.pythonhosted.orgpackagesd5b1c636b3dd0aad77bc45b6344c0aa4dd19694ebb67052b24bfdef35c23cd3cxonsh-0.18.4.tar.gz"
  sha256 "5ab71e3bd0650036995b457ce91f96be81fb3ef2959173e0396e7e83042e2952"
  license "BSD-2-Clause-Views"
  head "https:github.comxonshxonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4297e858130c4f8040dd94d828049647d999a36df33ba4cb3146f870f55a760b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe04f285e60d0412fdfbd60c09506044801fc1a0b28d262ecc5f458bbd31b659"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "240a420ca9c13980c9d5b0f3905e390cfe390ba2a54cd259bf58775f1ccf1302"
    sha256 cellar: :any_skip_relocation, sonoma:        "4734881668ace4b441e7d4b84e9149896af79084e587fffc770ebdaa052162f5"
    sha256 cellar: :any_skip_relocation, ventura:       "c20668af0961848bdbb56a9f1554fb75d3a36a72d519d34d9539f0765383c972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e916a9da9e0e11871221c7dbe2e5e6282fc9ccb1a52a15225b0a17713a7ff9d6"
  end

  depends_on "python@3.13"

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages2d4ffeb5e137aff82f7c7f3248267b97451da3644f6cdc218edfe549fb354127prompt_toolkit-3.0.48.tar.gz"
    sha256 "d6623ab0477a80df74e646bdbc93621143f5caf104206aa29294d53de1a03d90"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "setproctitle" do
    url "https:files.pythonhosted.orgpackagesffe1b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}xonsh -c 2+2")
  end
end