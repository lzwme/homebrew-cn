class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https:toolkit.translatehouse.org"
  url "https:files.pythonhosted.orgpackages84e05b163cce66be1f6a557b4a1c73c1a6c4ded941c8022069bc784f77968571translate_toolkit-3.14.3.tar.gz"
  sha256 "b588747b72b8befe76e34d16a720af57b4540c6f6d4cb0bb831107281a485824"
  license "GPL-2.0-or-later"
  head "https:github.comtranslatetranslate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1622e013b312cfa0e38f465bea9bebad56564a09bbf0a7fc3cf0e7852a2235b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23371c39d4236ce6d95c9b8265bbabf777836d7732b87a936a22f9d8b1071d29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1b718850fc4cba15dfa1c809d2b2d1cdf6bd2615074701ecee433ee297df2ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "0664a30ae4785c2e9663825774918412df02eeb90e3fe9d8ea1ec7bd8faf3f02"
    sha256 cellar: :any_skip_relocation, ventura:       "730071787a409a6d8c0158e71c429fe8523218ee62f73d9460048467c20fc5bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459f806454cad29380f4328828b3a83a143b22a795a3b3709c04dd5a02839e18"
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