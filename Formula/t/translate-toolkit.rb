class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https:toolkit.translatehouse.org"
  url "https:files.pythonhosted.orgpackagese062e87ea8be9fb831ee79b4b75e50d1eeb5959fe094b2cbe80e80c59d477fdatranslate_toolkit-3.13.5.tar.gz"
  sha256 "53c59c919e52a9787c0d1d7ccd34df9508e9f58bb84d1d52d27a9bda5203d768"
  license "GPL-2.0-or-later"
  head "https:github.comtranslatetranslate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6db360fabd01114cf00ba4514fbc6aeb87cc051ce1afbf555c4d6514c0e688e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "854ffe7c80b564de0a7155875debcef7012720cf8acf81000377ac9e82fc62de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2f8bf80e76a7b2243d9ab55f25fc93967eedda675312f1fa3ed9ed130fafcba"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbdd89288df1a92ff4d5e6c9fb4449afe28448525ec06fa30bb3361eff917c13"
    sha256 cellar: :any_skip_relocation, ventura:       "26d9b73151897199dd059a6c15dd921fb2af0ecbf52a925c013e808e68b30d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5597233a998092d31af122d9c6dc25e95953047f8b6f10edb946067885b0f659"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
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