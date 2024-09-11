class Unoconv < Formula
  include Language::Python::Virtualenv

  desc "Convert between any document format supported by OpenOffice"
  homepage "https:github.comunoconvunoconv"
  url "https:files.pythonhosted.orgpackagesab40b4cab1140087f3f07b2f6d7cb9ca1c14b9bdbb525d2d83a3b29c924fe9aeunoconv-0.9.0.tar.gz"
  sha256 "308ebfd98e67d898834876348b27caf41470cd853fbe2681cc7dacd8fd5e6031"
  license "GPL-2.0-only"
  revision 4
  head "https:github.comunoconvunoconv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "da0c5318947826ae48c016e4c5b80d263c807bf0e2c18ed53a464ec11b92e50d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8af20011a8567f3c979711096d8c65dc3eeb6ee134b5138372ebe6ab7bb25f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8af20011a8567f3c979711096d8c65dc3eeb6ee134b5138372ebe6ab7bb25f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8af20011a8567f3c979711096d8c65dc3eeb6ee134b5138372ebe6ab7bb25f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7da033bfdb25d20d669a453db4b17ca681078bd44c77e46fbf32baae5e27b1ad"
    sha256 cellar: :any_skip_relocation, ventura:        "7da033bfdb25d20d669a453db4b17ca681078bd44c77e46fbf32baae5e27b1ad"
    sha256 cellar: :any_skip_relocation, monterey:       "7da033bfdb25d20d669a453db4b17ca681078bd44c77e46fbf32baae5e27b1ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b46a9ee60e4247006945a036caca418b2f6e4e567643ec21c25e8f624f6a6aa"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages65d810a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  def install
    virtualenv_install_with_resources
    man1.install "docunoconv.1"
  end

  def caveats
    <<~EOS
      In order to use unoconv, a copy of LibreOffice between versions 3.6.0.1 - 4.3.x must be installed.
    EOS
  end

  test do
    assert_match "office installation", pipe_output("#{bin}unoconv 2>&1")
  end
end