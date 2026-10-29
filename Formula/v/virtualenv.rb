class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/b2/24/20282bc8e69ff8dee680dc2b95e9dc81fa7e7894b14c1a8d06330e97fef7/virtualenv-21.15.1.tar.gz"
  sha256 "e79c90b8f601701599c25905e02839924fede2c798d52325670d24fbdaab74ee"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e55c9ac64b526b77f6f473ee339ffed35d269891b12c731b490909a0e9c0901e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e55c9ac64b526b77f6f473ee339ffed35d269891b12c731b490909a0e9c0901e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e55c9ac64b526b77f6f473ee339ffed35d269891b12c731b490909a0e9c0901e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5d3ce05f4c0c440fab4e76f2971c4cdb49c7f92292f6600dd308fbb5a21f26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b5d3ce05f4c0c440fab4e76f2971c4cdb49c7f92292f6600dd308fbb5a21f26f"
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
    url "https://files.pythonhosted.org/packages/1a/43/8c4b5fe23f0e119cf4e1b16c2d16240ab9057cdbb138568c91d5a48abf81/platformdirs-4.13.6.tar.gz"
    sha256 "211d176e24674b5895dedf9021c262bcf9fad008a70610bfb147d4a8d6d8fe1b"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/8e/3e/0c8cbdb52feeac4a8667ccff3c58fd2568d6d2969db2717ff00a9fdae73a/python_discovery-1.6.6.tar.gz"
    sha256 "d687024fec55c489e7a465c7f5644300a4d9dbf7727a556a85660536ee922933"
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