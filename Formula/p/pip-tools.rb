class PipTools < Formula
  include Language::Python::Virtualenv

  desc "Locking and sync for Pip requirements files"
  homepage "https://pip-tools.readthedocs.io"
  url "https://files.pythonhosted.org/packages/1a/87/1ef453f10fb0772f43549686f924460cc0a2404b828b348f72c52cb2f5bf/pip-tools-7.4.1.tar.gz"
  sha256 "864826f5073864450e24dbeeb85ce3920cdfb09848a3d69ebf537b521f14bcc9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e4e5e1f2df083a08a9ecc5823f72f5e4924c72ab0dc4063224d4993bc7b54533"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cac576463253780d02b3de7afb7b0ba5548a0da843f98ff2dd3bca1efadc54d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cac576463253780d02b3de7afb7b0ba5548a0da843f98ff2dd3bca1efadc54d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cac576463253780d02b3de7afb7b0ba5548a0da843f98ff2dd3bca1efadc54d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc5695c7c95e4f104b71b0d7c16c117f8cd824266f2811b746e2aad5e2f7b735"
    sha256 cellar: :any_skip_relocation, ventura:        "fc5695c7c95e4f104b71b0d7c16c117f8cd824266f2811b746e2aad5e2f7b735"
    sha256 cellar: :any_skip_relocation, monterey:       "fc5695c7c95e4f104b71b0d7c16c117f8cd824266f2811b746e2aad5e2f7b735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c628f96e90b59465bfc0c0653c6bc9e1560e295e239fa7c820838c03ac5bb2"
  end

  depends_on "python@3.12"

  resource "build" do
    url "https://files.pythonhosted.org/packages/ce/9e/2d725d2f7729c6e79ca62aeb926492abbc06e25910dd30139d60a68bcb19/build-1.2.1.tar.gz"
    sha256 "526263f4870c26f26c433545579475377b2b7588b6f1eac76a001e873ae3e19d"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/c7/07/6f63dda440d4abb191b91dc383b472dae3dd9f37e4c1e4a5c3db150531c6/pyproject_hooks-1.1.0.tar.gz"
    sha256 "4b37730834edbd6bd37f26ece6b44802fb1c1ee2ece0e54ddff8bfc06db86965"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b8/d6/ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69/wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  def install
    virtualenv_install_with_resources

    %w[pip-compile pip-sync].each do |script|
      generate_completions_from_executable(bin/script,
                                           base_name:              script,
                                           shells:                 [:fish, :zsh],
                                           shell_parameter_format: :click)
    end
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      pip-tools
      typing-extensions
    EOS

    compiled = shell_output("#{bin}/pip-compile requirements.in -q -o -")
    assert_match "This file is autogenerated by pip-compile", compiled
    assert_match "# via pip-tools", compiled
  end
end