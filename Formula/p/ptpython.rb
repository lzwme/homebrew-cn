class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https:github.comprompt-toolkitptpython"
  url "https:files.pythonhosted.orgpackagesc9ce4441ac40762c73d74b48088a7311e368d28beec92602d66e632a59792a93ptpython-3.0.30.tar.gz"
  sha256 "51a07f9b8ebf8435a5aaeb22831cca4a52e87029771a2637df2763c79d3d8776"
  license "BSD-3-Clause"
  head "https:github.comprompt-toolkitptpython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e7da60db0a3a7a9381b6ec4142caee6d7c40ac26ed9f6cb685bbff0ab57596d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e7da60db0a3a7a9381b6ec4142caee6d7c40ac26ed9f6cb685bbff0ab57596d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e7da60db0a3a7a9381b6ec4142caee6d7c40ac26ed9f6cb685bbff0ab57596d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1cbfb4942dfdea16d8d36d99817f88c6685035c873bf6df156c5cb04b23ce7e"
    sha256 cellar: :any_skip_relocation, ventura:       "a1cbfb4942dfdea16d8d36d99817f88c6685035c873bf6df156c5cb04b23ce7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e7da60db0a3a7a9381b6ec4142caee6d7c40ac26ed9f6cb685bbff0ab57596d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7da60db0a3a7a9381b6ec4142caee6d7c40ac26ed9f6cb685bbff0ab57596d"
  end

  depends_on "python@3.13"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackages723a79a912fbd4d8dd6fbb02bf69afd3bb72cf0c729bb3063c6f4498603db17ajedi-0.19.2.tar.gz"
    sha256 "4770dc3de41bde3966b02eb84fbcf557fb33cce26ad23da12c742fb50ecb11f0"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackages669468e2e17afaa9169cf6412ab0f28623903be73d1b32e208d9e8e541bb086dparso-0.8.4.tar.gz"
    sha256 "eb3a7b58240fb99099a345571deecc0f9540ea5f4dd2fe14c2a99d6b281ab92d"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}ptpython test.py").chomp
  end
end