class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https:github.comjopohlurh"
  url "https:files.pythonhosted.orgpackagesd8dca6dcf5686e980530b23bc16936cd9c879c50da133f319f729da6d20bd95burh-2.9.6.tar.gz"
  sha256 "0dee42619009361e8f5f54d48f31e1c6cf24b171c773dd38f99a34111a0945e1"
  license "GPL-3.0-only"
  head "https:github.comjopohlurh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "85926c282e7134110066411902d8493f51e4b600c9928d23942cb0ef26414158"
    sha256 cellar: :any,                 arm64_ventura:  "13af4a878b54ccff9770d1861c284aaff23c1a40c080a4d3218686089d71eb2e"
    sha256 cellar: :any,                 arm64_monterey: "58be3a1068075e6306a3da6e1ba0562fa68c2052d6c8123bad7a08f3d2d0aab8"
    sha256 cellar: :any,                 sonoma:         "ae4ebd2a4d3a2c4ace6d2622a009223e29907e966512192594b9e856da0d95f1"
    sha256 cellar: :any,                 ventura:        "2e5758f7276bcb3647458e0ff86cbd181142ec762c959fc9a12abdd3a407088d"
    sha256 cellar: :any,                 monterey:       "7f4e434d39bab2752b16e629a71ff6f61bd776534c4053faed81e8f9029f24db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6753b0fdbd9b3e1a5419aecb36f0b3feacd6e0d1ca80b8783a252a86602b1fef"
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
      import site; site.addsitedir('#{Formula["libcython"].opt_libexecsite_packages}')
    EOS
    (libexecsite_packages"homebrew-libcython.pth").write pth_contents

    # We disable build isolation to avoid trying to build another numpy for build-only usage.
    # We can replace the virtualenv with pip install if we decide to link `libcython`.
    venv = virtualenv_create(libexec, python3)
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    (testpath"test.py").write <<~EOS
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    EOS
    system libexec"binpython3", "test.py"

    # test command-line functionality
    output = shell_output("#{bin}urh_cli -pm 0 0 -pm 1 100 -mo ASK -sps 100 -s 2e3 " \
                          "-m 1010111100001 -f 868.3e6 -d RTL-TCP -tx 2>devnull", 1)

    assert_match(Modulating, output)
    assert_match(Successfully modulated 1 messages, output)
  end
end