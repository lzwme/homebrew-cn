class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https:xon.sh"
  url "https:files.pythonhosted.orgpackages7382c39c24a07daf22877f2ffa0c53dca5cd7c84ccc2d647b6fd6cd134d7f022xonsh-0.18.3.tar.gz"
  sha256 "e57630d3f7e77e083618751402bf486bef51d2c42ed2abf3e0f4db388a50795f"
  license "BSD-2-Clause-Views"
  head "https:github.comxonshxonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "530d7aa3f66275f62bdf7cdd1fae836c2712a86204bb1e6e94587136a6f64a13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "326b317f207cab511c114353c3b31ed5dbb32e70829038108efcfc003801658e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d49bec68ed44bf429d1d88f9188a4d2b6119fc4a8ba21c2b8b6e4825451497b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "041c3bcc60a0d18e80b2aa984d3978bc20485522cd2e35b36573476f127e3aaa"
    sha256 cellar: :any_skip_relocation, ventura:        "a43ed7ecd0fba5b4bd05ceefbc12d3100c35769e87e6bdc15cc0238d459d052b"
    sha256 cellar: :any_skip_relocation, monterey:       "df71476647c8b2ca52623077e08c470b7f62272e76923e51f50b8ddf4c9f4a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4990f83b56501a22ba516f2722e1084b5157f1ac1a1efa8fc56ee33fc9184051"
  end

  depends_on "python@3.12"

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages476d0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879fprompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
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