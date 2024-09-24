class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https:toolkit.translatehouse.org"
  url "https:files.pythonhosted.orgpackages7f8a353ec691a8873624995a75aad1b969a6209dcc2bccdfc3fabfdbf9166bd8translate_toolkit-3.13.4.tar.gz"
  sha256 "774ab8c69377ef178b4a640c06b0c66651a3023e211df91acc6507ce5f3d5072"
  license "GPL-2.0-or-later"
  head "https:github.comtranslatetranslate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab16e32c938c60bd395e838fbf566486cbf69d4dd2d8d2f65143a2b20201f462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb42144ff0d8587e607a6331a627b375a3c36896f78708afc835ac5f5d373bd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a2167a1b85b1b5faedc05d6b360bba04c75673e9d351be418a883fe05a75ad1"
    sha256 cellar: :any_skip_relocation, sonoma:        "386f2d2f0674d300be441e748b39f56560b7f50e2660611e0a6171db94443146"
    sha256 cellar: :any_skip_relocation, ventura:       "bece606b3f29f5fbf63717de43ec794e2958d668ee00495299e99136f9349579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b177f9a0ef137eafd8b89ca6e0459b2fd8f105a31bd8834fd4d4a02ded31ae54"
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