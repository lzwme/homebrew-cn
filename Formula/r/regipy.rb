class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https:github.commkorman90regipy"
  url "https:files.pythonhosted.orgpackages6a230e77a9244d61360730b41b97b8e304d6729cbd2e35a5fddf82ef4c0efed4regipy-4.1.1.tar.gz"
  sha256 "532014352610c0cce9de2d6b5e43a5c80852eddca81edc3bfce55974c95d9a43"
  license "MIT"
  head "https:github.commkorman90regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02de67bccffa2392f89bbfb93a5fa143c99b8667349807f2d2350ac10f0e56c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f6d49932c9f2823b386951418c583988e9cdab6780f9bdb46d37f9ed0c34978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f44cad42bde8720c105fc56635674f3453bd991d9fae53c8c14c87012962a75"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fa34d39a1fcf60fc3ba6e01a45c0e41cdaf9451c2e27c109f57a36640b8f300"
    sha256 cellar: :any_skip_relocation, ventura:        "4f1391b8ff1db7201e86da39f95f7fc18241427e69c9105f979d65de0ce5e72d"
    sha256 cellar: :any_skip_relocation, monterey:       "872f7d94bcbf258289a413543b8894271590f9a895a07cbea208d9c953854f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60822d54d9956a1465abd20419f01f2ca94422197f1690b85a17ec8cb71a1dec"
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

    testpath.install resource("homebrew-test_hive")

    system bin"regipy-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
    h = JSON.parse(File.read("out.json"))
    assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
    assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
  end
end