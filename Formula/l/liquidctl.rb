class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https:github.comliquidctlliquidctl"
  url "https:files.pythonhosted.orgpackages99d915bfe9dc11f2910b7483693b0bab16a382e5ad16cee657ff8133b7cae56dliquidctl-1.13.0.tar.gz"
  sha256 "ee17241689c0bf3de43cf4d97822e344f5b57513d16dd160e37fa0e389a158c7"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comliquidctlliquidctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3a828e867857e71756dc5ffba6c1e36ccfc98e7260b760abf7bdf13bc22ed5a4"
    sha256 cellar: :any,                 arm64_sonoma:  "d0771969d4789fd3052849f504137a81635fb0fd94a7e4be89126738fc1df50b"
    sha256 cellar: :any,                 arm64_ventura: "23301c4754b90c1dc5ca433dd93d3187a324bd93fc903386098163fc2c17b36a"
    sha256 cellar: :any,                 sonoma:        "142261df22f7c5dfc176422dd5070df2131297c0d17b37f58d2763c0c1463097"
    sha256 cellar: :any,                 ventura:       "aa8d1e1e04c0b86ff2ee5eab36d15520844419b668701683015c9f3128102819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613025bf740c77d369eca1eb1fba8e2fcd759d82d6e95f9d923060de6e35bc89"
  end

  depends_on "pkg-config" => :build
  depends_on "hidapi"
  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.12"

  on_linux do
    depends_on "i2c-tools"
  end

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackagesdb382992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "crcmod" do
    url "https:files.pythonhosted.orgpackages6bb0e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5bcrcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https:files.pythonhosted.orgpackagesbf6f90c536b020a8e860f047a2839830a1ade3e1490e67336ecf489b4856eb7bhidapi-0.14.0.post2.tar.gz"
    sha256 "6c0e97ba6b059a309d51b495a8f0d5efbcea8756b640d98b6f6bb9fdef2458ac"
  end

  resource "pyusb" do
    url "https:files.pythonhosted.orgpackagesd96e433a5614132576289b8643fe598dd5d51b16e130fd591564be952e15bb45pyusb-1.2.1.tar.gz"
    sha256 "a4cc7404a203144754164b8b40994e2849fde1cfff06b08492f12fff9d9de7b9"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages27b8f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74bsetuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def install
    ENV["HIDAPI_SYSTEM_HIDAPI"] = ENV["HIDAPI_WITH_LIBUSB"] = "1"
    virtualenv_install_with_resources

    man_page = buildpath"liquidctl.8"
    # setting the is_macos register to 1 adjusts the man page for macOS
    inreplace man_page, ".nr is_macos 0", ".nr is_macos 1" if OS.mac?
    man8.install man_page

    (lib"udevrules.d").install Dir["extralinux*.rules"] if OS.linux?
  end

  test do
    system bin"liquidctl", "list", "--verbose", "--debug"
  end
end