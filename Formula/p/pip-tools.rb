class PipTools < Formula
  include Language::Python::Virtualenv

  desc "Locking and sync for Pip requirements files"
  homepage "https://pip-tools.readthedocs.io"
  url "https://files.pythonhosted.org/packages/1a/87/1ef453f10fb0772f43549686f924460cc0a2404b828b348f72c52cb2f5bf/pip-tools-7.4.1.tar.gz"
  sha256 "864826f5073864450e24dbeeb85ce3920cdfb09848a3d69ebf537b521f14bcc9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4298cc2457419c7dc3321845a2c987f947f412305a587ac3c22dd238ab385a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9ab40c60aab069bf5cd05dd4ccebbcc7bfd1db9b30ab5af31891d6a688f8442"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b756b9a1fec9ab44ac36a27ee5df828a1f7077d46f3125af2e6948602f22182a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a258aaf5046d40d5ffcbde8169e22c4ddade2f7520171187623e185e74823f08"
    sha256 cellar: :any_skip_relocation, ventura:        "33b3dd49ac84aa45a96a49ab9217e34c10c2b3b32a14e5c1401710ba78e4abe8"
    sha256 cellar: :any_skip_relocation, monterey:       "203a5b678ce84fd59fc24421db5f3754220e32113fd73f626f9a274e338a3873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8129218d506ac98a28071086fbd9aa891e86909ea2d1ca50d9e0fc4fd621ac9"
  end

  depends_on "python@3.12"

  resource "build" do
    url "https://files.pythonhosted.org/packages/55/f7/7bd626bc41b59152248087c1b56dd9f5d09c3f817b96075dc3cbda539dc7/build-1.1.1.tar.gz"
    sha256 "8eea65bb45b1aac2e734ba2cc8dad3a6d97d97901a395bd0ed3e7b46953d2a31"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
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