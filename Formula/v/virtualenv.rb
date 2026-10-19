class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/36/ce/7136eeccc4ff32c06c3b523745af49c5cf6b2e95635d88ae8519a6f4d25b/virtualenv-21.14.10.tar.gz"
  sha256 "f733501a49404c91b5bb1d34d107073b8f4b93a9a1ddb7e9a950eb8ce60f38ad"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1daa2ecb933f610ee7e2b68636008b51bbe6f755dca7829fcc81e62e6ac6717a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1daa2ecb933f610ee7e2b68636008b51bbe6f755dca7829fcc81e62e6ac6717a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1daa2ecb933f610ee7e2b68636008b51bbe6f755dca7829fcc81e62e6ac6717a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ccfcca973c8127996b3301b2c285ce10d3d5eb96a6a810d9df2e5b773f5885c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0ccfcca973c8127996b3301b2c285ce10d3d5eb96a6a810d9df2e5b773f5885c"
  end

  depends_on "python@3.15"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/98/771d8ca889f220d7d7e352addf500666368f0fd081c6080a83767580c6e4/filelock-4.2.1.tar.gz"
    sha256 "c4c937ccac2a813cee448e662a56366cfb374c0f8702e75f295c412cc1c5d5a3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/da/91/4a03cfdb03314cfca262921797fff04ff4054bd86a160aed76eddf8aa12b/platformdirs-4.13.3.tar.gz"
    sha256 "5e567f664eb087ab8521c0179cd8d1bd60857d271136567a39719e28e2d383ce"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/fc/54/fad125f5c48f7821644ee6f223ebfcedc4e23597c1a16eeb13d33aa4a91a/python_discovery-1.6.3.tar.gz"
    sha256 "a62b301d96cf5489cb96ab023b32e068421867fdd5df2e42eece877869047fa2"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end