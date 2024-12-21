class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.2.3.tar.gz"
  sha256 "6a533d7f0f488d5fb707fead07f3ad147b300fb87cbd7b8ec461cc1de3607d80"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6710568647019bb3b35f4c33f7bfdcdffcb01dd9fc6d5a667c285f82ec4cd2be"
    sha256 cellar: :any,                 arm64_sonoma:  "47fc652a8f4440f89b3aa868bf632db3c42f7ed99c0ff692c97f64d257399003"
    sha256 cellar: :any,                 arm64_ventura: "53e89ea25d7fabb787e987200e190e8d34373a2346af4a47cf79024de8da57b2"
    sha256 cellar: :any,                 sonoma:        "def00de628b604df0adc3c12996c99201844dc62b8096809ab8ccdb51db4d7f3"
    sha256 cellar: :any,                 ventura:       "9667512c8495ccc6c62989fdecddecf2afba489792339d6251976277abb84b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85edafa25ce4e6c8abd10befa81da319afb581a366fc4899b6125189eee1a0f8"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https:github.comfluentfluent-bitissues3393
    inreplace "srcCMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY libsystemdsystem)", "if(False)"
    inreplace "srcCMakeLists.txt", "elseif(IS_DIRECTORY usrshareupstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end