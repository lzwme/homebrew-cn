class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.2.0.tar.gz"
  sha256 "56c2c2c957dcef1f94410fac7b15c93675a2d08861a9b327a4847f16cfa74f71"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3d30a21ade65298bc812eedefc750fd4e3a5a8e4c6ee5876fbe949db61db0ae"
    sha256 cellar: :any,                 arm64_sonoma:  "6ba743d573c28c0c5bdaa23abc4da448a07015d05e1f7de075943c27d51b55f1"
    sha256 cellar: :any,                 arm64_ventura: "76c28028f4c6e9deb83182f872c04b8d8d5453bb28aa7ba020e0ade84219e7ce"
    sha256 cellar: :any,                 sonoma:        "caf951c0e7d658f1b4b54e04f94cc6e493dcaf77daa649d5b777d601c9bb299f"
    sha256 cellar: :any,                 ventura:       "4079f426883aebc116232f7f60b134d975326ab97b5180991282fdcd63651c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ced072c0d7fb2a696bcc4d1d730872daef6cdfcd51aebae852eab5302a421a4"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https:github.comfluentfluent-bitissues3393
    inreplace "srcCMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY libsystemdsystem)", "if(False)"
    inreplace "srcCMakeLists.txt", "elseif(IS_DIRECTORY usrshareupstart)", "elif(False)"

    args = std_cmake_args + %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end