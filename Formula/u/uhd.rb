class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https:files.ettus.commanual"
  url "https:github.comEttusResearchuhdarchiverefstagsv4.8.0.0.tar.gz"
  sha256 "a2159491949477dca67f5a9b05f5a80d8c2b32e91b95dd7fac8ddd3893e36d09"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https:github.comEttusResearchuhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "029c4215fed8f3bc2e30e31ef27772f836831cc5fef89b94712f0195e456b29e"
    sha256                               arm64_sonoma:  "455d66c8ab4b66ceea29e30a5197aa7cfa00b93370fb8ff5b26668d71803fbf5"
    sha256                               arm64_ventura: "f0edc58fa1e8483310cddcd4654d5195d5c09b44e658afaefda82ea4ef9f5732"
    sha256                               sonoma:        "b1d55671dfd15d6e46f6f5e1d570818c7d1ac3a32d33c462f849b77bd69a5392"
    sha256                               ventura:       "ec4910b5b59e7e15dbd6828fa6fcabfa283208b278988c1e894091c6c7ad9c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af77cb2f0c1a85487ad3ccd6a5a5f29849da2e7c05e25df346448a4bd02851d"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.13"

  on_linux do
    depends_on "ncurses"
  end

  resource "mako" do
    url "https:files.pythonhosted.orgpackages5fd98518279534ed7dace1795d5a47e49d5299dd0994eed1053996402a8902f9mako-1.3.8.tar.gz"
    sha256 "577b97e414580d3e088d47c2dbbe9594aa7a5146ed2875d4dfa9075af2dd3cc8"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  def python3
    "python3.13"
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