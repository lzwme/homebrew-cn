class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/65/c1/a49da20845f0f0e1afbb1c2586d406dc0acb84c26ae293bad6d7e7f718bc/scikit_image-0.22.0.tar.gz"
  sha256 "018d734df1d2da2719087d15f679d19285fce97cd37695103deadfaef2873236"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6ffbb862fd7a99014c09da60238b6cb963645842abef371b04b9d1f39d10ce1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "118e7278c3e134dc2b27f9f4b5bb8f95d122c4cf7e4226d7c324d051bd270371"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4891bdc3064a1d4861ac72a8370dd9220be9b59f10ed7674f78acb11383227c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "181777436397fa8568a644b4096295cab0b2be3f0841e75df3675cb5dbce2ab0"
    sha256 cellar: :any_skip_relocation, ventura:        "fc1a32d2fa0f3828f4af1af8af88e6092b829aa842c41f5b31c849186f3fbc9b"
    sha256 cellar: :any_skip_relocation, monterey:       "0b2f8a9385e13e9d4a7f7c3aecb302ee1db966d1e6f9c1588af30e201d9475a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85677ddc9e10921de4eb89be19631d4b2c9d4b1456d7ff9f16d40d63f64ec9df"
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
  depends_on "python@3.12"
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
    "python3.12"
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