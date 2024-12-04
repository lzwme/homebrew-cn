class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https:djlint.com"
  url "https:files.pythonhosted.orgpackagesffdda442814263f6ef16153f87fe78658097c6690106f53f0d2594bf4ee81202djlint-1.36.3.tar.gz"
  sha256 "d85735da34bc7ac93ad8ef9b4822cc2a23d5f0ce33f25438737b8dca1d404f78"
  license "GPL-3.0-or-later"
  head "https:github.comdjlintdjLint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf5ec3937b2c45003e27ece8d9d226acd734583cdfb21e2f6650769e7a142f8b"
    sha256 cellar: :any,                 arm64_sonoma:  "412df1673992ea25bf4164c28dd9b1e282819fb0b2de0c40076feafa74b17f42"
    sha256 cellar: :any,                 arm64_ventura: "e59df593650ab61b4d89ced74ec39e38eb432bb7c3982daf2179bdd7bfe7c675"
    sha256 cellar: :any,                 sonoma:        "a292cbc9d52eef8755cbd27ea35eef5d43a0a24cc27fbbcaec92e9a0ca768c10"
    sha256 cellar: :any,                 ventura:       "2482520049ffadc6209b80735c15ea68aa38dc9769c8c30accb741c972b38277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca01adda69151e8f3a763995895315cca8d4c7964455397c2a184d4cea746208"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssbeautifier" do
    url "https:files.pythonhosted.orgpackagese5669bfd2d69fb4479d38439076132a620972939f7949015563dce5e61d29a8bcssbeautifier-1.15.1.tar.gz"
    sha256 "9f7064362aedd559c55eeecf6b6bed65e05f33488dcbe39044f0403c26e1c006"
  end

  resource "editorconfig" do
    url "https:files.pythonhosted.orgpackages3d857b5c2fac7fdc37d959fab714b13b9acb75884490dcc0e8b1dc5e64105084EditorConfig-0.12.4.tar.gz"
    sha256 "24857fa1793917dd9ccf0c7810a07e05404ce9b823521c7dce22a4fb5d125f80"
  end

  resource "jsbeautifier" do
    url "https:files.pythonhosted.orgpackages693edd37e1a7223247e3ef94714abf572415b89c4e121c4af48e9e4c392e2ca0jsbeautifier-1.15.1.tar.gz"
    sha256 "ebd733b560704c602d744eafc839db60a1ee9326e30a2a80c4adb8718adc1b24"
  end

  resource "json5" do
    url "https:files.pythonhosted.orgpackages853dbbe62f3d0c05a689c711cff57b2e3ac3d3e526380adb7c781989f075115cjson5-0.10.0.tar.gz"
    sha256 "e66941c8f0a02026943c52c2eb34ebeb2a6f819a0be05920a6f5243cd30fd559"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_includes shell_output("#{bin}djlint --version"), version.to_s

    (testpath"test.html").write <<~HTML
      {% load static %}<!DOCTYPE html>
    HTML

    assert_includes shell_output("#{bin}djlint --reformat #{testpath}test.html", 1), "1 file was updated."
  end
end