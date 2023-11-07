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
    rebuild 1
    sha256                               arm64_sonoma:   "554f812585d412dee606291230167b08ab3b2b86a532e34b296eec8c2088b703"
    sha256                               arm64_ventura:  "8a42aa72c0a15d9c3604cc56cb19f1e9c73496a184485a1c7f20f12ad7c8448c"
    sha256                               arm64_monterey: "69a51f737c40227b6e08110f3190ecfada05fd5d875db376afa22e3b351a7c2f"
    sha256                               sonoma:         "e4b9c6068c0accf852fa430ac3fc718cadbf579bf2be6f4176038f9901cb4993"
    sha256                               ventura:        "699be5efeaea6b60750e815c183be24b3f615b83fe7cbd80e109bd602ff2145a"
    sha256                               monterey:       "79081a35d4f45cbe61903dd095fe9dde9ea1cecd4897bc1ac3ecba6e56e481f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58049be7948bed3c9e49547af2d40fdafdc41543a47d9c4a19c4d41d625148b1"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-mako" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.12"

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    system "cmake", "-S", "host", "-B", "host/build", "-DENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "host/build"
    system "cmake", "--install", "host/build"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end