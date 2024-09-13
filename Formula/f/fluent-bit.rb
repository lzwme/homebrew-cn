class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.1.7.tar.gz"
  sha256 "0b50a709d9fe3cc9fb462f4cd50240fa3cbe065c67c34f68d11e83421908855f"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia:  "508eeab025aa54cb06cbc2b11298f98b429f6c3da3e9fd0d351d6eec1b68a0ca"
    sha256                               arm64_sonoma:   "b2fee13a407cd59419bc3d073fb85f378fd26652a9163cd1d78286c6bfe9d365"
    sha256                               arm64_ventura:  "fecb7eefd5d9341c4050e1633c502cf27813b21f018d4e9d16caf50b9ca27148"
    sha256                               arm64_monterey: "969a51b8e1d01ebe566f893c316ea8c5debdbfea543d843d470f50eafd34fb17"
    sha256                               sonoma:         "b7debcaac1ae9b5d945b122bd0602d1b652a6ff34381f55608ef08a4be764d2f"
    sha256                               ventura:        "96a86583e89432e4de4e9ef7f74530d07021734bf141d3d21b956f1695eae91e"
    sha256                               monterey:       "5c72008f96aaa7fa45dde00e38d7ef70e7814c1cc4537b11e885583cdcc183b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c2117ddc2908ed07b1c2dffb59be875fe8ff28a3c55999e83eff004d62f0f0"
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