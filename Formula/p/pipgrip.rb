class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https:github.comddelangepipgrip"
  url "https:files.pythonhosted.orgpackagesfbdcf89b89e72e541bb5ffa25cbaf1f9c92d2c2187644c8972772aafb7bf0009pipgrip-0.10.13.tar.gz"
  sha256 "f481ef054c37036d334ca6f4b8608c1ca8a113e02e011276b540f1558dc394ba"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7dff1d3d2a7882be3bc3b2ab22ba026f5b437490bc5b8395f554f04f1ae3a67d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dff1d3d2a7882be3bc3b2ab22ba026f5b437490bc5b8395f554f04f1ae3a67d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dff1d3d2a7882be3bc3b2ab22ba026f5b437490bc5b8395f554f04f1ae3a67d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4cc6987ea55e8c4e576d82523e8ee1dfbd4b07e92e55e51aff797a1bef83f9f"
    sha256 cellar: :any_skip_relocation, ventura:        "b4cc6987ea55e8c4e576d82523e8ee1dfbd4b07e92e55e51aff797a1bef83f9f"
    sha256 cellar: :any_skip_relocation, monterey:       "b4cc6987ea55e8c4e576d82523e8ee1dfbd4b07e92e55e51aff797a1bef83f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11befbfc45817bc674484894aad95f49044514c423f6c650d14fde0633a07a09"
  end

  depends_on "python@3.12"

  resource "anytree" do
    url "https:files.pythonhosted.orgpackagesf9442dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7deaanytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesd64fb10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aedsetuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb8d6ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"pipgrip", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}pipgrip dxpy --no-cache-dir")
  end
end