class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https:xon.sh"
  url "https:files.pythonhosted.orgpackages13233631d79cd40d32af13dba303a212a8a1879177dd1f9a5ebd04eee8779650xonsh-0.19.0.tar.gz"
  sha256 "e90cd1a5d7f3ad576c9572b161cb37a1c27872fbb1f5707566bb4a38c6c897af"
  license "BSD-2-Clause-Views"
  head "https:github.comxonshxonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "062d05f0ad7b0fd1485dcf7f33506180df0a2b86411774f8d4883a2aeba36d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2509565fcdf8659904c12f101442b772ee836f1c921b20d2e9445257084570d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bce50a7bf04254fe24cfc360e453b4b23bdddac6826a2de681caee135210dff"
    sha256 cellar: :any_skip_relocation, sonoma:        "11335c504ea06eca60e209735f5c0a9a4947c22eecb1e10de70ddc15b529f939"
    sha256 cellar: :any_skip_relocation, ventura:       "39a75eb7df88f7a793209417cbde9d76cf0755b2ca240a2d314f5fccd64f9c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faa7d91758ac13cfb4e1546afa6f6afe351618a41e1e043c2498e6c8a020e584"
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
    url "https:files.pythonhosted.orgpackagesae4eb09341b19b9ceb8b4c67298ab4a08ef7a4abdd3016c7bb152e9b6379031dsetproctitle-1.3.4.tar.gz"
    sha256 "3b40d32a3e1f04e94231ed6dfee0da9e43b4f9c6b5450d53e6dd7754c34e0c50"
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