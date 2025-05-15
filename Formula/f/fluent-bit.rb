class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv4.0.2.tar.gz"
  sha256 "aa0577ba7251081c8d5398b2a905b5b0585bb657ca13b39a5e12931437516f08"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d270c67a24aec520f00acf750403b858a2d0a9c51a29ad13a187751d31a8288b"
    sha256 cellar: :any,                 arm64_sonoma:  "72a79201b4154ebf7d87d9ca263a29b2f855c7c3e3cd23f2816ac51fa2b72b70"
    sha256 cellar: :any,                 arm64_ventura: "65fef7fecffcc6d9cbb9f06ecf5fb91334e9ce8301b507af4ae9fd171998acf1"
    sha256 cellar: :any,                 sonoma:        "c5efdefcec66e92268feb578595863ae304d982fe409c6319b974237208e7f21"
    sha256 cellar: :any,                 ventura:       "001e84633ed9ebe0a348852e73acd5d3b9fccdd5e4927218517324e9645cbd62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61207b5b10e226bcc259346c95b14d0a27120532496003a3223877032861a528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "774f4a73f7d67633d6a09c029e9e8adbd958aa1cd41f05e37914569038657ff9"
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
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
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