class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https:github.commkorman90regipy"
  url "https:files.pythonhosted.orgpackagese0f261846ba036f840b3cfe9b412dca3ef629bdc7506faafbd56b2c8de987950regipy-3.1.6.tar.gz"
  sha256 "edc9fd8501f3374afd49020550bf361235e569959712825fbd2f444d2aeca8d9"
  license "MIT"
  head "https:github.commkorman90regipy.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0f5b70e7210ce898c375f096df2ee9e77d2b3b325f9937fed77dd5b471f233d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32472339585d076ea7dfff5a9435b7b5d27339a76cec8c0e7f2899d978554fce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03301b4d9141850ae7a6dee1b9a532983a5798864da4029ee160161b6d00d5af"
    sha256 cellar: :any_skip_relocation, sonoma:         "2214a8184bc23860d55158d2be50ed0daaf57f70b49e99fedff521bcd1a07934"
    sha256 cellar: :any_skip_relocation, ventura:        "22f26ff2cb32cc1628eb37880922e10c5f03dea4389cc512392b7f8b9c5386dc"
    sha256 cellar: :any_skip_relocation, monterey:       "13f4c0708d20973339bf87e9ca92954e4de4747a11442283e158e7ba90597cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f87410a4cec277cbd048971d97842ad6eb42019ef60a62d72ca0f48594177fff"
  end

  depends_on "python@3.12"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
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
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
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

    resource("homebrew-test_hive").stage do
      system bin"registry-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
      h = JSON.parse(File.read("out.json"))
      assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
      assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
    end
  end
end