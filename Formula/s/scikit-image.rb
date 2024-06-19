class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https:scikit-image.org"
  url "https:files.pythonhosted.orgpackages5dc5bcd66bf5aae5587d3b4b69c74bee30889c46c9778e858942ce93a030e1f3scikit_image-0.24.0.tar.gz"
  sha256 "5d16efe95da8edbeb363e0c4157b99becbd650a60b77f6e3af5768b66cf007ab"
  license "BSD-3-Clause"
  head "https:github.comscikit-imagescikit-image.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8aa4f1756355a294e4b26c6aa395fc7fdbdd574c00d82b87558d7d384eb119e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "912a19ba94573aa3ea604743fba82b30bfb10c8de80c9330fa5888c5319dff92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067eeccfb003e88003969d0bb31d0e9f10eea326790054bb65bdcfecc0bc14a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c5a0842b9be549e1acb25ec8265b971a425da52d0269435db64e0cb5ae40f8c"
    sha256 cellar: :any_skip_relocation, ventura:        "9736500714362a642c82459ad66fe961b1a3def18ed97d4cb87538f7f22f563b"
    sha256 cellar: :any_skip_relocation, monterey:       "5556ac9f3acc51b9773bf191fca8ee866686bbdbcefe64d82e251fe6276139ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56c69786ae7d70ec8cd3a24b775b50e2643f333cf60605a2779a8932692e7f53"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "scipy"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "imageio" do
    url "https:files.pythonhosted.orgpackages2cf9aa9f3a4eae46f4727902516dc7b365356c1e4e883156532b74d135a69887imageio-2.34.1.tar.gz"
    sha256 "f13eb76e4922f936ac4a7fec77ce8a783e63b93543d4ea3e40793a6cabd9ac7d"
  end

  resource "lazy-loader" do
    url "https:files.pythonhosted.orgpackages6f6bc875b30a1ba490860c93da4cabf479e03f584eba06fe5963f6f6644653d8lazy_loader-0.4.tar.gz"
    sha256 "47c75182589b91a4e1a85a136c074285a5ad4d9f39c63e0d7fb76391c4574cd1"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackages04e6b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ecnetworkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "tifffile" do
    url "https:files.pythonhosted.orgpackages8de5c58f2dc22f6372516d1154ce1874c74cecf7c52892ad5f09bf3764b6b1b2tifffile-2024.6.18.tar.gz"
    sha256 "57e0d2a034bcb6287ea3155d8716508dfac86443a257f6502b57ee7f8a33b3b6"
  end

  def install
    virtualenv_install_with_resources
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