class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/50/67/b5d37693e5e666b68100db8fe34f00db28279330db55f739a3c799ff2449/virtualenv-21.14.1.tar.gz"
  sha256 "719b189804e66678017d9f63bbfc590c44f6b96ab4829513806394f9b375929c"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3d4558a972a8be4005c5dac22b31c40e43c5c5422be488a90f3136e57ee1558"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3d4558a972a8be4005c5dac22b31c40e43c5c5422be488a90f3136e57ee1558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3d4558a972a8be4005c5dac22b31c40e43c5c5422be488a90f3136e57ee1558"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bfb8d9556dfba9830634e47593d8b589783e8a5dd9e6eba5e2869d73f6d44e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bfb8d9556dfba9830634e47593d8b589783e8a5dd9e6eba5e2869d73f6d44e0f"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/35/f5/14097cca69f53794270d8c7970b48321636302affe3154c7e0ba114eeff9/filelock-4.0.7.tar.gz"
    sha256 "da5915714a70b55d167fdc7e251ad91302b0a36816fb574dfafae8f4f2c9bb21"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/17/c8/721b3855fe457da514fe249247d404b9b39c5d16532278f70ebaa6acf18b/platformdirs-4.12.2.tar.gz"
    sha256 "eab5f70271a490ef74618bb314fbb86e3c7e82fa3b9c922c2ea0e0a1a155d329"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/57/250bd238b966cece44328235eb85290045d059265fdaf7527a3a958123db/python_discovery-1.6.1.tar.gz"
    sha256 "cf87d3627dfb4412437fdd5b13eae402607722998d21567993aedbc59b23c15e"
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