class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https:toolkit.translatehouse.org"
  url "https:files.pythonhosted.orgpackages28f1e009a798bc2d697c5920e7a5454e20356eaab04b11648f3f014ceda3f7d0translate_toolkit-3.15.0.tar.gz"
  sha256 "d7a7af5d2afa667c1b7abfd435231577ceada16646b303d240eed8e724826086"
  license "GPL-2.0-or-later"
  head "https:github.comtranslatetranslate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23bd868b2e390c02bc5098e2dac9e09c9924607ed0ca50c844c36f540f20dcb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b559bab97b85b88a54d2c7c0f1a0747beb39cff9d0dc8d96a7adc3d849c8c4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55e64269154508a5415a1f1f364506407c8d506e58f69541d12363d5d027ded5"
    sha256 cellar: :any_skip_relocation, sonoma:        "147424e6e0876df34b2765b5bf6ae8298eaf07c6898118002ffc736f5c356bc5"
    sha256 cellar: :any_skip_relocation, ventura:       "4969718cd21e5d0eb6a2784745dd2c0962e2c8552244ec3b7735d631fb7dcd39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f4a7aa88a9bdfde581b6ff2d7b3113fe62a86d26e72fd11c07fcbff74cb6ca4"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https:files.pythonhosted.orgpackages237603fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackageseff6c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}podebug --version")
  end
end