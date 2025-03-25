class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https:github.comnxp-imxmfgtools"
  url "https:github.comnxp-imxmfgtoolsreleasesdownloaduuu_1.5.201uuu_source-uuu_1.5.201.tar.gz"
  sha256 "c763b87ffdf10ac5499a0c319463759caa336bc6567b56d6d0ef448590c1a76d"
  license "BSD-3-Clause"
  head "https:github.comnxp-imxmfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex((?:uuu[._-])?v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "02a11844bc1d48ac72b4e6ce82a5325c38023f53de9d58cfa45148000d9c2270"
    sha256 arm64_sonoma:  "7fb0bf7f0fb5d7e9f428d98d500daf3f3c8a721b23eb1187d2c4e3785004606a"
    sha256 arm64_ventura: "a7dbb4dd0967afb3f747dfbf84257a48f8a4fed067e4f76d6997dba6eaf34747"
    sha256 sonoma:        "6773e6f293f4eb2a8ac298ca7035970d9e26ba2379b020dc3e3a6c4e74d14775"
    sha256 ventura:       "7fead959d22f46f47ef56de8f0de054b66bfe7115ff155b66a17346d757c7aab"
    sha256 arm64_linux:   "a68e9bffd0c8555a36213fb6ed4e9f64b5bfc356b3ceb4ec57bca56f01eff301"
    sha256 x86_64_linux:  "68d4fb9b7c85d21ccba50ab8aa60f5cef6ef6d9d3befaee32deecc5bce6377a6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libusb"
  depends_on "libzip"
  depends_on "openssl@3"
  depends_on "tinyxml2"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Universal Update Utility", shell_output("#{bin}uuu -h")

    cmd_result = shell_output("#{bin}uuu -dry FB: ucmd setenv fastboot_buffer ${loadaddr}")
    assert_match "Wait for Known USB Device Appear", cmd_result
    assert_match "Start Cmd:FB: ucmd setenv fastboot_buffer", cmd_result
    assert_match "Okay", cmd_result
  end
end