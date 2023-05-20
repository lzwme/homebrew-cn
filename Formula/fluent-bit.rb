class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghproxy.com/https://github.com/fluent/fluent-bit/archive/v2.1.3.tar.gz"
  sha256 "b7dd91649d6a7e899c4bee6c0e564c66b931ce62b560f083e6d259ee4030a7c7"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "8f9de4fa6d25ee0e9ed88ce985251ef3d6f54e497580e26b080af3f20514f0ca"
    sha256 arm64_monterey: "d5bddf9abebf17e2a6350205bb39f209686f9fed93bd65bae7efacba745bfd34"
    sha256 arm64_big_sur:  "86e0629328c6c0df3998de5b4924c480c9613c71846e5b70ae79508755d8d9b8"
    sha256 ventura:        "d88af193ab8b52fa94a36508836a2095ee7155ded5ac838c6d08ed0941926fb4"
    sha256 monterey:       "1c8e61f1ea3a4ef8fab6f1dbbf58a48140baa2c66f7830d14d3530b8f62af74c"
    sha256 big_sur:        "dd1684df6eea725cda5f676240ba05e8ddf9c39e9b1154bf7a2de19f2e168d9b"
    sha256 x86_64_linux:   "ef358b19388af96ca7f998f5cc5e51ac0ec7cc495b3b1c8d9fc94a946c88a447"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end