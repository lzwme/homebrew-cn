class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.6.0.0",
      revision: "50fa3baa2e11ea3b30d5a7e397558e9ae76d8b00"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "9d9bbe423f7b7c2c71b8dc073586963771bdbfb035a6cb4e11becfc1c76ae5fc"
    sha256                               arm64_ventura:  "685c06d0059ccdd6622a987e545b873cbac2952fd1fb2eacfa83d84b69f316bd"
    sha256                               arm64_monterey: "87de0479c5439eb3b7dbfff6bd64ce0beec486f4c45c159f5fe07dd98f0550c1"
    sha256                               sonoma:         "0c563f267209c1334f1900606135ec3dd3f1eb1cfebfe2b6d38fed71a6faeed3"
    sha256                               ventura:        "b99b93a93aa37c95bfbb7f013bc0dcd7d15023c837420ef69a34a03be50ae5ef"
    sha256                               monterey:       "fe0d306684277144020498f84a77f0666bec521e4b61ae9ee0e4969d87ea9c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e314b2e94684bb8ef793fa8b64de52d56d038f495c1db7166649c06521b10bf"
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