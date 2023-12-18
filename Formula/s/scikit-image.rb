class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https:scikit-image.org"
  url "https:files.pythonhosted.orgpackages65c1a49da20845f0f0e1afbb1c2586d406dc0acb84c26ae293bad6d7e7f718bcscikit_image-0.22.0.tar.gz"
  sha256 "018d734df1d2da2719087d15f679d19285fce97cd37695103deadfaef2873236"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comscikit-imagescikit-image.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd1db9cce79197508fccbc39747ea3e73a32fde20570f1b04a5976afa473153a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36bbb80bdcbd7006c8ac5cf455362e2a5ab3d6db2681c2d6798f2b8b969b6ff9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "783d14ad0663ef04049ad0d86608a00c1ae67d9c825ae79561e0cb558b717006"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b4449ac4a1df85ad8bde5e4e716d501c787c7f77669da51217b26c69f850027"
    sha256 cellar: :any_skip_relocation, ventura:        "56fe3cb6085942201e15a9fe4cddc2a9d4c683c222cb4a800f6ad7e9577d5090"
    sha256 cellar: :any_skip_relocation, monterey:       "576a0b7dc7e672b1e4c8248da9ef438a88059c8bad81d085bf0065b9bb71e469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67288d99340a9f0aabc28585a3f5808346eb2574cd6330d190a8317152bdc903"
  end

  depends_on "libcython" => :build
  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pythran" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python-networkx"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "scipy"

  resource "imageio" do
    url "https:files.pythonhosted.orgpackages90699448c0156936b437e3803e185e3d991afd8b5413a90e848cdcc038fc0303imageio-2.32.0.tar.gz"
    sha256 "e425ad36c605308d9ea6d93eda7b0987926059b8b86220e142a599a7975128dd"
  end

  resource "lazy-loader" do
    url "https:files.pythonhosted.orgpackages0e3a1630a735bfdf9eb857a3b9a53317a1e1658ea97a1b4b39dcb0f71dae81f8lazy_loader-0.3.tar.gz"
    sha256 "3b68898e34f5b2a29daaaac172c6555512d0f32074f147e2254e4a6d9d838f37"
  end

  resource "tifffile" do
    url "https:files.pythonhosted.orgpackages15b2ce2911ff31123c957d26f8c0c1bc9b496cfe35038e133ecda28a859e7310tifffile-2023.9.26.tar.gz"
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
      library_dirs = #{HOMEBREW_PREFIX}lib
      include_dirs = #{HOMEBREW_PREFIX}include
    EOS
    (libexec"site.cfg").write config

    site_packages = Language::Python.site_packages(python3)
    paths = %w[pillow numpy scipy].map { |p| Formula[p].opt_libexecsite_packages }
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")

    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexecsite_packages
    ENV.prepend_path "PYTHONPATH", Formula["pythran"].opt_libexecsite_packages
    ENV.prepend_path "PATH", Formula["libcython"].opt_libexec"bin"
    python_exe = libexec"binpython"
    system python_exe, "-m", "pip", "install", *std_pip_args, "."
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https:github.comHomebrewhomebrew-pythonissues185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}libpython*.*site-packagesskimage***.pyc"]
  end

  test do
    (testpath"test.py").write <<~EOS
      import skimage as ski
      import numpy

      cat = ski.data.chelsea()
      assert isinstance(cat, numpy.ndarray)
      assert cat.shape == (300, 451, 3)
    EOS
    shell_output("#{libexec}binpython test.py")
  end
end