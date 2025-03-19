class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.2.9.tar.gz"
  sha256 "40d0d9dd196674b0d2057b4f7811ce63969fee5b0e097b6b9c392720e7e18976"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e23fca1f24a8e2926415dd738a10ff4ae351849dd3eb412b7c492f0518bd1ee2"
    sha256 cellar: :any,                 arm64_sonoma:  "31e0856f5d47ea4444c6ce812c02c799ddcd8209b9fcfe5e7831f569128c61be"
    sha256 cellar: :any,                 arm64_ventura: "d0d99be07697cb5b7d2a73b3fa8c29a7b673695bc6b2ea887a24152bf6a85de2"
    sha256 cellar: :any,                 sonoma:        "f329445501da4b2b98f86c0aabfc60d686b937fa85a369b10ba2500dc7d99e77"
    sha256 cellar: :any,                 ventura:       "c59caf6608e6a1fdcbeced7b2bdde2bbafd553a0e6aad2e1e8289604690dcb6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8182eb452239bf604de5fda8cc7535021fae4a445cd5cd5efc9567bec22d13e7"
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