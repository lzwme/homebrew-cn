class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https:github.commkorman90regipy"
  url "https:files.pythonhosted.orgpackages927dc6266028167cf368d496a0e90e257b5ac35e9241d5c8d5c0bfdb852c4162regipy-5.1.0.tar.gz"
  sha256 "c2f7a468e5d21c376ac50097b7e148cd43fe17ccaf8b8a28b51dce26e6caf62e"
  license "MIT"
  head "https:github.commkorman90regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b8680428b8d9719be198a0def5ea04023041146033c68519d5d3a4251311f7c1"
  end

  depends_on "python@3.13"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "construct" do
    url "https:files.pythonhosted.orgpackages02778c84b98eca70d245a2a956452f21d57930d22ab88cbeed9290ca630cf03fconstruct-2.10.70.tar.gz"
    sha256 "4d2472f9684731e58cc9c56c463be63baa1447d674e0d66aeb5627b22f512c29"
  end

  resource "inflection" do
    url "https:files.pythonhosted.orgpackagese17e691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages3a313c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3fpytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test_hive" do
      url "https:raw.githubusercontent.commkorman90regipy71acd6a65bdee11ff776dbd44870adad4632404cregipy_testsdataSYSTEM.xz"
      sha256 "b1582ab413f089e746da0528c2394f077d6f53dd4e68b877ffb2667bd027b0b0"
    end

    testpath.install resource("homebrew-test_hive")

    system bin"regipy-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
    h = JSON.parse(File.read("out.json"))
    assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
    assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
  end
end