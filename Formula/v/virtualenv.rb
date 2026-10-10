class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/92/f3/589727d02bc832750cfa00ced4315d127535a22a6d7cfcb369b2fe219a2e/virtualenv-21.14.6.tar.gz"
  sha256 "c6b74616e64bffa9532cfa9dfd54ffbab0dc9b999df2bb8ec0d75e559b983661"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b93c98ef69ed6cf562a83bb61b6025524c6aea19af0b1ba0c598ae594b0cfdfd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b93c98ef69ed6cf562a83bb61b6025524c6aea19af0b1ba0c598ae594b0cfdfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b93c98ef69ed6cf562a83bb61b6025524c6aea19af0b1ba0c598ae594b0cfdfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a846fa2eb2b2d1255e40671ee4f71959fc287006433bce6df51c52c7535a5e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a846fa2eb2b2d1255e40671ee4f71959fc287006433bce6df51c52c7535a5e87"
  end

  depends_on "python@3.15"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/53/e4/34efcb869715cf299e47d1ac7b2624d2bcb6f2d3dffc2f0abe8417f65ab2/filelock-4.0.12.tar.gz"
    sha256 "cf42711a7ac791818b299fab0332a088c65aeeefa36290de98db92c434303b0c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/90/a1/d5f9002a70298c64a789779077d8dd90c10aa1f47fe40c86802df874f2a6/platformdirs-4.12.4.tar.gz"
    sha256 "63743c02414e755de4e31b8f68125c1407495b86c5a006e203c01ff8b9924250"
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