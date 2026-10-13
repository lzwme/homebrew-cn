class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/dc/3f/935cf1757643381fb7f7cc98197b4bc119223d9c2cf37dc3b03ad2a4455f/virtualenv-21.14.7.tar.gz"
  sha256 "5f427d56f39eb7e7447d641dd4b7ab1e9c92793f498f35f26da2e4972c5546ae"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc6c118232d70dd7315ee832f89dd67c8688523e779a4f6eda1f68f06f31aec5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc6c118232d70dd7315ee832f89dd67c8688523e779a4f6eda1f68f06f31aec5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc6c118232d70dd7315ee832f89dd67c8688523e779a4f6eda1f68f06f31aec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3bfc2e51423a3a8726cbec1622d7d865727d98e9a99dfaf54f0adf2b9d9b2636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3bfc2e51423a3a8726cbec1622d7d865727d98e9a99dfaf54f0adf2b9d9b2636"
  end

  depends_on "python@3.15"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/35/c8/1d457d9150ff948f2ce6ada7715e0eeebbe5d3b58a45271a1e222474bcd3/filelock-4.1.1.tar.gz"
    sha256 "7ba0927482c5a814b0a7f391d029ccdb8010f576f0a74c0dcde1811e8bc4c1b6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/b0/73/54993df8fc57e906dc9b7e01d1d9b0b2d3eb0ce3190639e33dccb12853f7/python_discovery-1.6.2.tar.gz"
    sha256 "cd1738ca1d37c86ef9d0b654dd46fcee1e41c97c6add12575e8501ced39afdb4"
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