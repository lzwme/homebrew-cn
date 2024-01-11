class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https:github.comddelangepipgrip"
  url "https:files.pythonhosted.orgpackagesffd5ddf2f6edc7a6da2e31071340c38b2d71c3a8b99ffccf3652bb6965a8ab52pipgrip-0.10.12.tar.gz"
  sha256 "4ff9bee6158eed27fe5b609c3504eaaea57709401592057e88656663457fc9d7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c29e20678785e7ac9de3a8e2ce453a31372a678f9469e3a3c1ef2ac084e34b8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce811dc9a509c3e8d7a7ef88245bf512104bc2c99b1b135fde5ef5f3c8e560a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec9072f4b80c73feafe10c872414730f376a8919773ac2e20fa58d639be6c931"
    sha256 cellar: :any_skip_relocation, sonoma:         "10bd75fe5f01d6194f81cb5b6c3b23e7b056aa94a0f66f739219c00b2b8bc470"
    sha256 cellar: :any_skip_relocation, ventura:        "6d445a272b99c0b451928d920c52f5e8469c14150486abf304a454870794d09e"
    sha256 cellar: :any_skip_relocation, monterey:       "38cc3b837a6a716314b9c5f196ef9b66c404b931feb39ff61b6f1a765388f4e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b0c96b68642d7c42e8d2ed1b1612615da7fec8d104364fcff89fe077020fa3d"
  end

  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "anytree" do
    url "https:files.pythonhosted.orgpackagesf9442dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7deaanytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb0b4bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97bwheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
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