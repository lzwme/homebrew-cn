class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.1.10.tar.gz"
  sha256 "9ec909e8ce04bc8f3b09862c781956c40da18f60e8ae92b154114b4e20edc5fa"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "e687bfb03915076572f9ef9d2780b936d09872f0aabc073863f77a3c8c6797bc"
    sha256                               arm64_sonoma:  "ea5f44ff5cebdb3d049a034b19e7b119e48f1445367261c241659c3bc0f4eb5b"
    sha256                               arm64_ventura: "a5f7f177cf0b97e520ebb528c1491e180f53228f712fc4d3c59e15e6c34c0f7e"
    sha256                               sonoma:        "1441ff0479c630be311a02efccc466d71d40911eda808450d799b09f5f7db421"
    sha256                               ventura:       "64ffb7982f220857e16a70a8b7d5f4b4791355230da1f127362a8452350b0db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9fcac7189e69a8ba33c0b9e3f20600914a55ef20915e30902c437f8f6caf666"
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