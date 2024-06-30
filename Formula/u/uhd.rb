class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https:files.ettus.commanual"
  url "https:github.comEttusResearchuhdarchiverefstagsv4.7.0.0.tar.gz"
  sha256 "afe56842587ce72d6a57535a2b15c061905f0a039abcc9d79f0106f072a00d10"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https:github.comEttusResearchuhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "515e4ab3658dfe37936db6628082d7ae184bcdb5469b20d31d905f910f4358b4"
    sha256                               arm64_ventura:  "32722cc8c33002d500a7fe60cd3ebcbf594bff0ae700b133e2c99cfcbdfd8013"
    sha256                               arm64_monterey: "a18ec633ab705207b9046b40e045681bfc759877685e93951dcd5aeed0b6c33d"
    sha256                               sonoma:         "766eb76e84e6ee233b5e5c1be4be6b88bae7df6693dcec3a7dc87f779266fac3"
    sha256                               ventura:        "9d4e4d8f7517f2b7f000cbdc11204c2ecf699321861ab330c370132b2f79c44c"
    sha256                               monterey:       "ec05ebb1f005947853565daba578f0106abbd3c6c7d759835dfb55ce1d78c294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72779009ae52578530dff2121a07c16e59f032961286e1910cfd8731159e548c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.12"

  on_linux do
    depends_on "ncurses"
  end

  fails_with gcc: "5"

  resource "mako" do
    url "https:files.pythonhosted.orgpackages6703fb5ba97ff65ce64f6d35b582aacffc26b693a98053fa831ab43a437cbddbMako-1.3.5.tar.gz"
    sha256 "48dbc20568c1d276a2698b36d968fa76161bf127194907ea6fc594fa81f943bc"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  def python3
    "python3.12"
  end

  def install
    venv = virtualenv_create(buildpath"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    system "cmake", "-S", "host", "-B", "build",
                    "-DENABLE_TESTS=OFF",
                    "-DUHD_VERSION=#{version}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}uhd_config_info --version")
  end
end