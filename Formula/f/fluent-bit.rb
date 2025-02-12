class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.2.6.tar.gz"
  sha256 "eb4d8f49c50d092f8986a5fb0ac23c47004da403d1daf182884c8a71167c7002"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e30768d92dce85945561a2d0713090a43f30ebd388ea404b802ce05e644c31c0"
    sha256 cellar: :any,                 arm64_sonoma:  "8b451dc2418097f7267537777ab2b83e378aee02a71cec58d8a1808c560af47f"
    sha256 cellar: :any,                 arm64_ventura: "92d39f69004a2c57dd5b232b24d81db43413dbabafb7f114faff7aea643d8345"
    sha256 cellar: :any,                 sonoma:        "feb9d40387d67cb0107390c0fc480edd888494afb82f0950497769f4910fb3ed"
    sha256 cellar: :any,                 ventura:       "36ab12c694af593a43287e46885a59d3f681d46564d1c7d79fda78d322d50374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7764beb21c4ac64868abf762d50bb4fc8c3e4a1481712bcc7cec673d173e67fb"
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