class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/65/c1/a49da20845f0f0e1afbb1c2586d406dc0acb84c26ae293bad6d7e7f718bc/scikit_image-0.22.0.tar.gz"
  sha256 "018d734df1d2da2719087d15f679d19285fce97cd37695103deadfaef2873236"
  license "BSD-3-Clause"
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14dc715dc566ceb423e058f4b9be7c3c1145453a8c85a6c93911286b2c8c3c73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "086cad269e43bfbeb38a3229665c9eeb7669339907634527166789f56460dcf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "612d04cf228f8801eb968a44a12fc3703831daeb9c6fe0e21feacf43c0d7b7e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "b741902f152a8f66315700c81749188ed1c4cf02b201cfb6e4d077cf4f67c3ad"
    sha256 cellar: :any_skip_relocation, ventura:        "fdb2a512b3a97c4d0d9bd726838b240ec05057acb82905ff60d7391b4c1fdf8a"
    sha256 cellar: :any_skip_relocation, monterey:       "d3f33c9709f8ccb7afc58906518e657a18fc7ce3dc4adb7f57e9364026195075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d7978fe5f86cce29a0fba68497bd75dca9c23cf37dc7bc9ed73d2087b60f56c"
  end

  depends_on "libcython" => :build
  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pythran" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "scipy"

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/90/69/9448c0156936b437e3803e185e3d991afd8b5413a90e848cdcc038fc0303/imageio-2.32.0.tar.gz"
    sha256 "e425ad36c605308d9ea6d93eda7b0987926059b8b86220e142a599a7975128dd"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/0e/3a/1630a735bfdf9eb857a3b9a53317a1e1658ea97a1b4b39dcb0f71dae81f8/lazy_loader-0.3.tar.gz"
    sha256 "3b68898e34f5b2a29daaaac172c6555512d0f32074f147e2254e4a6d9d838f37"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/15/b2/ce2911ff31123c957d26f8c0c1bc9b496cfe35038e133ecda28a859e7310/tifffile-2023.9.26.tar.gz"
    sha256 "67e355e4595aab397f8405d04afe1b4ae7c6f62a44e22d933fee1a571a48c7ae"
  end

  def python3
    "python3.11"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    config = <<~EOS
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
    EOS
    (libexec/"site.cfg").write config

    site_packages = Language::Python.site_packages(python3)
    paths = %w[pillow numpy scipy].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["pythran"].opt_libexec/site_packages
    ENV.prepend_path "PATH", Formula["libcython"].opt_libexec/"bin"
    python_exe = libexec/"bin/python"
    system python_exe, "-m", "pip", "install", *std_pip_args, "."
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/skimage/**/*.pyc"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      import skimage as ski
      import numpy

      cat = ski.data.chelsea()
      assert isinstance(cat, numpy.ndarray)
      assert cat.shape == (300, 451, 3)
    EOS
    shell_output("#{libexec}/bin/python test.py")
  end
end