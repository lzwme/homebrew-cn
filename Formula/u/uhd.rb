class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://ghfast.top/https://github.com/EttusResearch/uhd/archive/refs/tags/v4.10.0.0.tar.gz"
  sha256 "a9c66b52abcd586b513999f3a52345807b7551d01efac8c98eed813838be0297"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  compatibility_version 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "cd5b441f00ef5d17de9210d49ceb932aba4b50e17789d348fd4e12b376292ae2"
    sha256                               arm64_sequoia: "5bf766413fbf535fdd67c71e6e8a3b20ce2ea25cfa2bfcd320018b4c160990c5"
    sha256                               arm64_sonoma:  "2b3fa297397a34f85060937ee5b1583634e08ef0e3618b61a3df7c674b37ffb6"
    sha256                               sonoma:        "353869166ccb0896940857f6e19d5922f977f7059f52278775b427851f696537"
    sha256                               arm64_linux:   "67855b9f56adcab9cf90e0ef681712e8d62d0e15c0ee2813a88cdf4dae6347ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb4c3d549f0565c0d008512e50f52871b830b89f61f546b8be3e5128efed813"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.14"

  on_linux do
    depends_on "ncurses"
  end

  pypi_packages package_name:   "",
                extra_packages: "mako"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/59/8a/805404d0c0b9f3d7a326475ca008db57aea9c5c9f2e1e39ed0faa335571c/mako-1.3.11.tar.gz"
    sha256 "071eb4ab4c5010443152255d77db7faa6ce5916f35226eb02dc34479b6858069"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  def python3
    "python3.14"
  end

  def install
    # Boost 1.89+ compatibility
    inreplace "host/cmake/Modules/UHDConfig.cmake.in", /\s+system\n/, ""

    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    args = %W[
      -DENABLE_TESTS=OFF
      -DUHD_VERSION=#{version}
    ]
    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end