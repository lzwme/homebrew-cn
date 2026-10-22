class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/c9/2c/1a69b3346931e9a7db9cc00cc0fa847c843a85fa7cf52a598f57261c68df/virtualenv-21.14.12.tar.gz"
  sha256 "bbcfb78e36c22ad70c6917c4aecb5e63477d3c138e9f88c946f320e31859c76a"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0d389a33649470435046480500c7ac4f6e138a6841b949478312b2a217f48ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0d389a33649470435046480500c7ac4f6e138a6841b949478312b2a217f48ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0d389a33649470435046480500c7ac4f6e138a6841b949478312b2a217f48ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "94431d989c00bdc794e9996a62a4046678b2ce19a7779fa4e8906b6e52f2e9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "94431d989c00bdc794e9996a62a4046678b2ce19a7779fa4e8906b6e52f2e9d9"
  end

  depends_on "python@3.15"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d8/28/3893324bcadf8f89b1616637468d766af3f625008c0735bf704fdfa86617/filelock-4.2.4.tar.gz"
    sha256 "c6d8663535e1650ee430507b4ffbac7b464dd64b7647ea0112a9f406499d163d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/f3/ee/cf608372c88ce2c136ee13c69ab6f667dbc0d0c1176af188b4ddc8853e66/python_discovery-1.6.4.tar.gz"
    sha256 "bc70d31f0ec5de11eda13d4d64c16e24b3506a65984684f2b6c98cb83b2ea9df"
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