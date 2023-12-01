class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/1c/c4/e72ccab675d835e3a8632fc145dcb10fc0b3f0f290e958e34c3e126ee6e7/pipgrip-0.10.11.tar.gz"
  sha256 "cb845fd8dcc64c975eb586c18d2fdd7f39a0d10bf7bd0d70b38639eba19d3dc7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abee6d8eeea0c0fc5087ca313f66340475d06c1532a564e9982703bc3bfb4d68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74cd37fc1e5f50881d55ec0e2da2f5cbdf6526e9b5ad7d0052e1bbba4dd82872"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dcd5a69bb02c3b7fe7df3482a489d1904b0fbf52e2bf2ced931734b2a525838"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba2143db6f4383fcce585589f11bd31f21c9319ce804477ad2a96dd0971ac1c8"
    sha256 cellar: :any_skip_relocation, ventura:        "112a3c942ff7d617075543e765836d492bfe02bef2714ba75a1ace40ce13d78b"
    sha256 cellar: :any_skip_relocation, monterey:       "defdb63f2d833b67f6d6d30b2f597a8d1ee79c88b9c9cfd8e06ca3db6dd4063a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85071eb20332b5697662caac935a97cd1da5fb7c2d4cb41fd0cf55b42087cc94"
  end

  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end