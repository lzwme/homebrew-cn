class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/49/4b/b1a4236c6e3dbcf215a3b1ded8e7ff1af6ca02155c230c40e9b1db0a5376/urh-2.9.5.tar.gz"
  sha256 "eb621df420e0f15cf7fe98bceac6beb453c909e88c3fad05066f034ea578f406"
  license "GPL-3.0-only"
  head "https://github.com/jopohl/urh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ead1182b0e0ecc33490ca4e5c1f905313e5dfe5fc3417f050073ba1c6043ac2"
    sha256 cellar: :any,                 arm64_ventura:  "98448be5e683cb6766c6c3bc34244af7569488665d2b682212ad2323ad4ef27f"
    sha256 cellar: :any,                 arm64_monterey: "5c66054e666159046daa2b2f56c04a91977bbe24d81340ff354e746d03a0327b"
    sha256 cellar: :any,                 sonoma:         "55ffaa570b46ee8c4618725dd553a28709c3017f9763489e6fd21495e4bfc92b"
    sha256 cellar: :any,                 ventura:        "2efb7fe8bf8f29911b10bf80134c14434e7b555e32f2aa818154dacda46c642f"
    sha256 cellar: :any,                 monterey:       "45afb31a54dbc3b5250fc9a1f4ca02306876c0924234a955e5f6f5ea2b31a5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "014b3a0dba1d8d681cc266a156c3c30d0888e9727ca0367b8832d76d04c76fc8"
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "libcython"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python-psutil"
  depends_on "python@3.11"

  def install
    python3 = "python3.11"

    # Enable finding cython, which is keg-only
    site_packages = Language::Python.site_packages(python3)
    pth_contents = <<~EOS
      import site; site.addsitedir('#{Formula["libcython"].opt_libexec/site_packages}')
    EOS
    (libexec/site_packages/"homebrew-libcython.pth").write pth_contents

    virtualenv_install_with_resources
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