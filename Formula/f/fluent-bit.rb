class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v4.0.6.tar.gz"
  sha256 "8aa2ffc93c03c8fd451edb78723a1f87dd61c1997cd128bfa07d7225670b35eb"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4889783afc642cab35cb349fc155e3f587e561cc8d096996b67b6f1f1fa3ceab"
    sha256 cellar: :any,                 arm64_sonoma:  "cf2a2fe70dba495bb8026a28ee39f004cb6c976caff7083a545115a62cd98afb"
    sha256 cellar: :any,                 arm64_ventura: "291486f343e7a60b11706a742b70e602425c517d1e31f1ffafd98240e15e5289"
    sha256 cellar: :any,                 sonoma:        "c5d244b3eff93b39faa611392046f697d3b938b3940203837fb5e5442130a586"
    sha256 cellar: :any,                 ventura:       "0623e336df418ceb60b0f970f10312828b7638aa782c03a4eae636c0d8cc1a93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b682c0efe66116a4d9c754838cdc8242b65eaa901b858da327167887ca9d2c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9a15bec7e01f7e73b1c780a787b58a93b25faff17aba78555015bbb38d3cc0c"
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
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end