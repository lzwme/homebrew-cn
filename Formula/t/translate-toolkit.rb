class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https:toolkit.translatehouse.org"
  url "https:files.pythonhosted.orgpackages39c20fc369321be3500f8121253378e9c38b6ef8fcc259c56751bbf04c8b2895translate_toolkit-3.14.2.tar.gz"
  sha256 "3105c14e54164f691e8d1de92094bc4d5c374248e0ed51f521547abd79059807"
  license "GPL-2.0-or-later"
  head "https:github.comtranslatetranslate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c2f54abee117003ee2c296e3cd7683571ad4e58ab21701a9849ac1536b88702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae563988c9cf4413501f038bc76d89c90d8cf15cf3580a631fa9da477784ed24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "639933356e6fc504387b60fbc5df6284f634829799f3be5768f49d7fbadaed9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac181359d8865a887ae8b109016e35abf66aa2675ed6c6083aa321075722ae9b"
    sha256 cellar: :any_skip_relocation, ventura:       "f0573a8d987492e9a64d8a3007c4b5916beb528b5b4f4dffcb19f3787042a757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4a812e87cbe5643ee252e0d396ac2a950216d3e78e421f81e2b77efab73dc57"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https:files.pythonhosted.orgpackages95e3275e359662052888bbb262b947d3f157aaf685aaeef4efc8393e4f36d8aacwcwidth-0.1.9.tar.gz"
    sha256 "f19d11a0148d4a8cacd064c96e93bca8ce3415a186ae8204038f45e108db76b8"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
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