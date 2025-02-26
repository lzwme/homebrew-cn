class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.2.7.tar.gz"
  sha256 "bbc1c0d2a12932c316967931346520af38b1306af26f86b9b2e8bff1fc333f80"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8fe2fad37baff7ba9f07e4bcf444bdebf39d2d928eccad8aef2625780804f909"
    sha256 cellar: :any,                 arm64_sonoma:  "b67e134d32734a90f7da0d02eaffd95fbd7fa77bd308baa003a4c910df15e825"
    sha256 cellar: :any,                 arm64_ventura: "f387c51a6956a36eaac9fb55308b4d6362e22ef4c365736df0df3c672b857d95"
    sha256 cellar: :any,                 sonoma:        "7464d4c07e5a51addbbdac2a2cfd7730560da6bdb538fce79051227af1ec90c5"
    sha256 cellar: :any,                 ventura:       "622ccdb39ab15a8f6a95f567361f9181a9827e67c5bf295bf26c921b383225f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "337b631c3aa3291d7b7b0e9906a025a27377f5fc8172dc4d302557e995a47142"
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