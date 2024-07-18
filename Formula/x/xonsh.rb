class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https:xon.sh"
  url "https:files.pythonhosted.orgpackages33f756ce182e31011161bcd5362f4dc73192f7f1b0f622b930e05ebce1da9915xonsh-0.18.1.tar.gz"
  sha256 "b3063ae7606c7b7177a0135e0850fb1dca6ed234401401aa22dc10529b2d2cb8"
  license "BSD-2-Clause-Views"
  head "https:github.comxonshxonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "449a756fa09651137399bd62f0cb1aee302054a3009c25851d2b3458bf78a331"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f084989ffd20013fec107a54e68f14952c8da8174c8c592bb77d6effc8db0556"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa0b599ee86adf1e57a84151fe3486eea7f1f4b600d9049ff8dc523e6288e7e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bb557f8b317853b19adc7d4f58a06ec5a3487f3ac88b3984315d99b7f120ffd"
    sha256 cellar: :any_skip_relocation, ventura:        "501a2493b7a1f94fab41805d5a212861e3b9d1e40acf35a539a54d107b053399"
    sha256 cellar: :any_skip_relocation, monterey:       "87029fd016c388e79381cfd95efc816edc7f3acca61ca6f0a4371680b1b7c17f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64b05aff9b229296fc58300e87241420b95885b899bd46a599362784e046602f"
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