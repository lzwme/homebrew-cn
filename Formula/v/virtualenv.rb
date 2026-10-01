class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/7c/0c/e419d453f81fee6c01b40f30a38e45a9418c6877b1edee00bc71aedcf7b2/virtualenv-21.14.0.tar.gz"
  sha256 "c3c0dbdf7259316edbb993020206ee7f7664a33063292dcc4a618e4c04cdf450"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "773b418c5967afab85ee84e949bee64dd35f1eee326f2d677e137ba642aedab4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "773b418c5967afab85ee84e949bee64dd35f1eee326f2d677e137ba642aedab4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "773b418c5967afab85ee84e949bee64dd35f1eee326f2d677e137ba642aedab4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a79635b490d332215b975eca29dbc73142870e3c7df6931e1593e0a2707a69fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a79635b490d332215b975eca29dbc73142870e3c7df6931e1593e0a2707a69fd"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/2b/2d/5cb7a5ac017031e96a63173f3d57a8a5162ce36f9ff461e62bc6da4d88ab/filelock-4.0.6.tar.gz"
    sha256 "323fab3b2fb22d889b29fa83774f60029addddb4b6a1bcfa1e73066eabffb5f2"
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

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end