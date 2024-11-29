class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https:github.comjopohlurh"
  url "https:files.pythonhosted.orgpackagesd8dca6dcf5686e980530b23bc16936cd9c879c50da133f319f729da6d20bd95burh-2.9.6.tar.gz"
  sha256 "0dee42619009361e8f5f54d48f31e1c6cf24b171c773dd38f99a34111a0945e1"
  license "GPL-3.0-only"
  revision 2
  head "https:github.comjopohlurh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a245b652c23f045e0126d444e311284ff745e55abb0eeec71fcd5fcea51463b"
    sha256 cellar: :any,                 arm64_sonoma:  "c95d3a91199338f0f7c7d9908a0c73b34ac26adac714e045ac30d5a162440e5c"
    sha256 cellar: :any,                 arm64_ventura: "6908cc6ffac8f16ac0462417d02e1761630a6a338cb03a8b339be40feb465101"
    sha256 cellar: :any,                 sonoma:        "531cf6900e8e2f404fbf7f191b4d38ee0d82ff217a9fb68292ff8ab9e7561744"
    sha256 cellar: :any,                 ventura:       "a2333202e0587108f7641225da241da61c735062a9a0704596afdb6d598d047a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c07f1091b4d163888bde7bfce246c3c94cbfeb8ba76b982dbbdd4f75cef4a16"
  end

  depends_on "pkgconf" => :build
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python@3.13"

  resource "cython" do
    url "https:files.pythonhosted.orgpackages844db720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aacython-3.0.11.tar.gz"
    sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages26102a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources
    # Need to disable build isolation and install Setuptools since `urh` only
    # has a setup.py which assumes Cython and Setuptools are already installed
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    (testpath"test.py").write <<~PYTHON
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    PYTHON
    system libexec"binpython3", "test.py"

    # test command-line functionality
    output = shell_output("#{bin}urh_cli -pm 0 0 -pm 1 100 -mo ASK -sps 100 -s 2e3 " \
                          "-m 1010111100001 -f 868.3e6 -d RTL-TCP -tx 2>devnull", 1)

    assert_match(Modulating, output)
    assert_match(Successfully modulated 1 messages, output)
  end
end