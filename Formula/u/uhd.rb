class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.5.0.0",
      revision: "471af98f6b595f5fd52d62303287d968ed2a8d0b"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "868130cfd963f85e583d36c4d477ac7f873b2bdca426e61f9ed3a1cf6379dfd0"
    sha256                               arm64_ventura:  "1d62d4ea0f93ff6b419e51c7e7840389cfa45d2854bb7efa9b1cf4ed05c60918"
    sha256                               arm64_monterey: "4958f85e04f42938b30c7bbada54f653dfbd23e109349f13115cfc8cbe141780"
    sha256                               sonoma:         "49c1a1781c3d8938dde4e46c54117f7fe3fcbbec75174eae338d855184e34c6d"
    sha256                               ventura:        "e9814fc96289b2043b6eff90b8e8fd67e654af30349d08a5c577138501eeca87"
    sha256                               monterey:       "3898f0c2fa76cbd4d52f91c9ed6592ff48e5460a108da4498c1dc8f66fc57f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92eaf78000344362d308accf167557e25eb551a0736bab01dd122721190c4fe"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python-markupsafe"
  depends_on "python@3.11"

  fails_with gcc: "5"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  def python3
    "python3.11"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python3)

    resource("mako").stage do
      system python3, *Language::Python.setup_install_args(libexec/"vendor", python3)
    end

    system "cmake", "-S", "host", "-B", "host/build", "-DENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "host/build"
    system "cmake", "--install", "host/build"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end