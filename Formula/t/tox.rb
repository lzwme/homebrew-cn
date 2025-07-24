class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/2c/a3/6fdc3f17aad7f2971739c6efc537a692d619c54acb224d90e62733346a60/tox-4.28.1.tar.gz"
  sha256 "227ce1fdfea7763107aed3a8ac87d74b1bd1240ad7dd9c37fc2cb2b318006520"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "478963671ee5cd84755c7dbe7c5a4666e6531afd6ff2ecb7c646d323d9b293af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "478963671ee5cd84755c7dbe7c5a4666e6531afd6ff2ecb7c646d323d9b293af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "478963671ee5cd84755c7dbe7c5a4666e6531afd6ff2ecb7c646d323d9b293af"
    sha256 cellar: :any_skip_relocation, sonoma:        "62c72633876d537b369112346d5b5d9bca8a5859854b48690cf71d3bcb4138c4"
    sha256 cellar: :any_skip_relocation, ventura:       "62c72633876d537b369112346d5b5d9bca8a5859854b48690cf71d3bcb4138c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dd8a74768850f04d72b4e33f314f7091ea65733cfddf9e041297a0087df54af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dd8a74768850f04d72b4e33f314f7091ea65733cfddf9e041297a0087df54af"
  end

  depends_on "python@3.13"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/8a/89/817ad5d0411f136c484d535952aef74af9b25e0d99e90cdffbe121e6d628/cachetools-6.1.0.tar.gz"
    sha256 "b4c4f404392848db3ce7aac34950d17be4d864da4b8b66911008e430bc544587"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/19/fd/437901c891f58a7b9096511750247535e891d2d5a5a6eefbc9386a2b41d5/pyproject_api-1.9.1.tar.gz"
    sha256 "43c9918f49daab37e302038fc1aed54a8c7a91a9fa935d00b9a485f37e0f5335"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a9/96/0834f30fa08dca3738614e6a9d42752b6420ee94e58971d702118f7cfd30/virtualenv-20.32.0.tar.gz"
    sha256 "886bf75cadfdc964674e6e33eb74d787dff31ca314ceace03ca5810620f4ecf0"
  end

  def install
    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(Formula["python@3.13"].opt_bin/"python3.13").to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~PYTHON
      def test_trivial():
          assert True
    PYTHON
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_path_exists testpath/"src/.tox/py#{pyver}"
  end
end