class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https:ipython.org"
  url "https:files.pythonhosted.orgpackages1c5afacbb5a0650e68b16134ce787b0990ee47f8b67316b0d844d9b183f212e6ipython-8.25.0.tar.gz"
  sha256 "c6ed726a140b6e725b911528f80439c534fac915246af3efc39440a6b0f9d716"
  license "BSD-3-Clause"
  head "https:github.comipythonipython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c306d90491b102d5772a9d15c81d502696d09b4f90c32e025985ec808ed697f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c306d90491b102d5772a9d15c81d502696d09b4f90c32e025985ec808ed697f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c306d90491b102d5772a9d15c81d502696d09b4f90c32e025985ec808ed697f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff4047e5d5bc870fb9f5ca4e37a6bf20e87108bc113cbd1b6cec1bf9775435be"
    sha256 cellar: :any_skip_relocation, ventura:        "ff4047e5d5bc870fb9f5ca4e37a6bf20e87108bc113cbd1b6cec1bf9775435be"
    sha256 cellar: :any_skip_relocation, monterey:       "ff4047e5d5bc870fb9f5ca4e37a6bf20e87108bc113cbd1b6cec1bf9775435be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df27fda2248a361778a471df6593ff3fd4e56b5c7329536ced84192a5dc99b46"
  end

  depends_on "python@3.12"

  resource "asttokens" do
    url "https:files.pythonhosted.orgpackages451df03bcb60c4a3212e15f99a56085d93093a497718adf828d050b9d675da81asttokens-2.4.1.tar.gz"
    sha256 "b03869718ba9a6eb027e134bfdf69f38a236d681c83c160d510768af11254ba0"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "executing" do
    url "https:files.pythonhosted.orgpackages084185d2d28466fca93737592b7f3cc456d1cfd6bcd401beceeba17e8e792b50executing-2.0.1.tar.gz"
    sha256 "35afe2ce3affba8ee97f2d69927fa823b08b472b7b994e36a52a964b93d16147"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackagesd69999b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0ajedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "matplotlib-inline" do
    url "https:files.pythonhosted.orgpackages995ba36a337438a14116b16480db471ad061c36c3694df7c2084a0da7ba538b7matplotlib_inline-0.1.7.tar.gz"
    sha256 "8423b23ec666be3d16e16b60bdd8ac4e86e840ebd1dd11a30b9f117f2fa0ab90"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackages669468e2e17afaa9169cf6412ab0f28623903be73d1b32e208d9e8e541bb086dparso-0.8.4.tar.gz"
    sha256 "eb3a7b58240fb99099a345571deecc0f9540ea5f4dd2fe14c2a99d6b281ab92d"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages661060dfbae0c000879066656fc15bb8d0d1d4235ead415959defcbeb57ee060prompt_toolkit-3.0.45.tar.gz"
    sha256 "07c60ee4ab7b7e90824b61afa840c8f5aad2d46b3e2e10acc33d8ecc94a49089"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https:files.pythonhosted.orgpackages975a0bc937c25d3ce4e0a74335222aee05455d6afa2888032185f8ab50cdf6fdpure_eval-0.2.2.tar.gz"
    sha256 "2b45320af6dfaa1750f543d714b6d1c520a1688dec6fd24d339063ce0aaa9ac3"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "stack-data" do
    url "https:files.pythonhosted.orgpackages28e355dcc2cfbc3ca9c29519eb6884dd1415ecb53b0e934862d3559ddcb7e20bstack_data-0.6.3.tar.gz"
    sha256 "836a778de4fec4dcd1dcd89ed8abff8a221f58308462e1c4aa2a3cf30148f0b9"
  end

  resource "traitlets" do
    url "https:files.pythonhosted.orgpackageseb7972064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    man1.install libexec"sharemanman1ipython.1"
  end

  test do
    assert_equal "4", shell_output("#{bin}ipython -c 'print(2+2)'").chomp
  end
end