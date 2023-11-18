class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/49/4b/b1a4236c6e3dbcf215a3b1ded8e7ff1af6ca02155c230c40e9b1db0a5376/urh-2.9.5.tar.gz"
  sha256 "eb621df420e0f15cf7fe98bceac6beb453c909e88c3fad05066f034ea578f406"
  license "GPL-3.0-only"
  head "https://github.com/jopohl/urh.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ad61c232478ac7b456cd3713a7a3d87d663b6e9d01218f10c0366c79588677f9"
    sha256 cellar: :any,                 arm64_ventura:  "9ea899a6df94c9d97f9bf795b693651e8b2bea1fa17d167a220f2ed571672f8c"
    sha256 cellar: :any,                 arm64_monterey: "de41e4e2e98dd2c791d3a08f4f2dd394c2ae72773fa1f21be87941cf58b5daad"
    sha256 cellar: :any,                 sonoma:         "0d7af4b9dda3efb846cb47ff97627077884fd84380c7b5c51cb7bc58da91c329"
    sha256 cellar: :any,                 ventura:        "401f29ab2e995b37fe14b21898e4e7ec874377583dc4e54f2a4ce03499e1f5ba"
    sha256 cellar: :any,                 monterey:       "5aa0d23ee74dae5cbc2a9db225bf230b6bf52ebae3aeb701cc834985f7e9588e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa8eec6f5246fa1b88cfd865bc954213c42f1644d277799c0ccfc793cf575fe7"
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "libcython"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python-psutil"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  def install
    python3 = "python3.12"

    # Enable finding cython, which is keg-only
    site_packages = Language::Python.site_packages(python3)
    pth_contents = <<~EOS
      import site; site.addsitedir('#{Formula["libcython"].opt_libexec/site_packages}')
    EOS
    (libexec/site_packages/"homebrew-libcython.pth").write pth_contents

    # We disable build isolation to avoid trying to build another numpy for build-only usage.
    # We can replace the virtualenv with pip install if we decide to link `libcython`.
    venv = virtualenv_create(libexec, python3)
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    (testpath/"test.py").write <<~EOS
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    EOS
    system libexec/"bin/python3", "test.py"

    # test command-line functionality
    output = shell_output("#{bin}/urh_cli -pm 0 0 -pm 1 100 -mo ASK -sps 100 -s 2e3 " \
                          "-m 1010111100001 -f 868.3e6 -d RTL-TCP -tx 2>/dev/null", 1)

    assert_match(/Modulating/, output)
    assert_match(/Successfully modulated 1 messages/, output)
  end
end