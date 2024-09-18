class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.1.8.tar.gz"
  sha256 "406868b86f87c2d6c4c633f5e7208f983751539b2d0938dcb4e0103530265f26"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "336251073fcf277a2cd459da4ab1e9598dd73417d5b11555f1fd82ad36ed3945"
    sha256                               arm64_sonoma:  "062ff7da1a23ea6c1a312ba5e5dcdd4c695009e977b0d73bb1e3fe904c12a3ae"
    sha256                               arm64_ventura: "4af81d4943008d46d9a2ac87da64aafa32ac3bd1e5b4c961781ab76f86bf4609"
    sha256                               sonoma:        "2b6f2bc8664e95120cdb345b52b35b95c8e77ac08bd2a7c7ba1c877e21d4fad2"
    sha256                               ventura:       "2d70913ed414aa98c39cf222ed87eccadbca5a51829b2a2ed1f913617aa29304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "787b1d05e5364d63c98bfa0bf377db899444d8c72c4402eccf4720211d479e34"
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