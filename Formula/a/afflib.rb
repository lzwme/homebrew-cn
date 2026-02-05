class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://ghfast.top/https://github.com/sshock/AFFLIBv3/archive/refs/tags/v3.7.22.tar.gz"
  sha256 "67481fc520ff927bf61aea0bf2d660feb73e24cc329335bebb064f8f12115dcb"
  license all_of: [
    "BSD-4-Clause", # AFFLIB 2.0a14 and before
    :public_domain, # contributions after 2.0a14
  ]

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "9a772d0a336e905a1767e3c586d84debc611e6454ededab652796aad2e090228"
    sha256 cellar: :any,                 arm64_sequoia: "a9d9c1f61cb011a1d6e6821f0580ba1f3c954678589830fe09a11f4d51047d73"
    sha256 cellar: :any,                 arm64_sonoma:  "d3c16b4ecf8dc8e145e5cdce928ab097d01aed19aeebe7b913d3bd91bd40fe8e"
    sha256 cellar: :any,                 sonoma:        "2f300b83d63ae1edf6de56181cbf2c725a2b04454c151be873b8edbd8285ae3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c116c26b668c185c8b717071313ea2011c0ed75727e7e44f13ef5344dfd38f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb7251a3abe994ef7fcebe3066738bd94b1d4ea84e35ce74f1a5bef97a42877"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def python3
    which("python3.14")
  end

  def install
    # BSD-4-Clause is GPL-incompatible so cannot be linked to GPL readline
    # https://www.gnu.org/licenses/gpl-faq.html#OrigBSD
    # https://src.fedoraproject.org/rpms/afflib/blob/f43/f/afflib.spec#_36-38
    odie "readline cannot be a dependency!" if deps.map(&:name).include?("readline")
    ENV["ac_cv_lib_readline_readline"] = "no" unless OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-fuse",
                          "--disable-python",
                          "--disable-silent-rules",
                          "--enable-s3",
                          *std_configure_args
    system "make", "install"

    # We install Python bindings with pip rather than `./configure --enable-python` to avoid
    # managing Setuptools dependency and modifying Makefile to work around our sysconfig patch.
    # As a side effect, we need to imitate the Makefile and provide paths to headers/libraries.
    ENV.append_to_cflags "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./pyaff"
  end

  test do
    system bin/"affcat", "-v"

    system python3, "-c", "import pyaff"
  end
end