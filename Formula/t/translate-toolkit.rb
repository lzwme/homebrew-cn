class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https:toolkit.translatehouse.org"
  url "https:files.pythonhosted.orgpackages35759d8b19b70987d67f28a9d2b6c3c56fd5cb08ff044b79c7a74f80e904f52ftranslate_toolkit-3.14.5.tar.gz"
  sha256 "2846180b74a0b8cb7f51e7a70ae410c1310e9be37b7c6c849247c049e5c53dd0"
  license "GPL-2.0-or-later"
  head "https:github.comtranslatetranslate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c506967c347b3120842c77fa700bc69ec1b800278c46ab9d7029e3985febbde8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f8acf442ef2fa367aea71beecfc2e27f1d732e5c2aae603bd74230f8eaaef3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19494a50fe9012588c28c5033d49474a5bac76762a1ef7f868e3e353054bcd2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "69a37a25ffcf745c6a51f4cccf83683c6fcf95fd3224fdae18d8340231a258fe"
    sha256 cellar: :any_skip_relocation, ventura:       "8809590db01b43c409f45241ada9c254d1e6e35c4f16c97a7490d706d977101e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fca62293095dd924c6effb322407f39ee4556da6a1aa18fdff492d874ddc6ff8"
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