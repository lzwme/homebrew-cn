class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https:github.comlibrespot-orglibrespot"
  license "MIT"
  head "https:github.comlibrespot-orglibrespot.git", branch: "dev"

  stable do
    url "https:github.comlibrespot-orglibrespotarchiverefstagsv0.4.2.tar.gz"
    sha256 "cc8cb81bdbaa5abf366170dec5e6b8c0ecf570a7cb68f04483e9f7eed338ca61"

    # Use `llvm@15` to work around build failure with LLVM Clang 16 (Apple Clang 15)
    # described in https:github.comrust-langrust-bindgenissues2312.
    # TODO: Remove in the next release
    depends_on "llvm@15" => :build if DevelopmentTools.clang_build_version >= 1500
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdf1c044110646a9b99b887b96f927202929dbcb77f47359e3c4c31cf2820b92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "569548eaf0db6750a015fad03d89b14e62f5e1d2abd60f6c0f9b5435d7fc2d0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfe8d20853c7a525d7949e0f4715df8e02a0a313c5f93c8de37d0bb7b8ce863c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a417c3c1a0d53820b5c5a5a3f652d7a20521c2a4891fb1763815e4c7a0dfca10"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1154ef2c059ef08c469a75266323d344b8d16376d8309f719cf375d88b0e5f2"
    sha256 cellar: :any_skip_relocation, ventura:        "b1cb3bb5049f14ca3e95ea59c88e969f2d4ae8057dde82c73526333e84124b2e"
    sha256 cellar: :any_skip_relocation, monterey:       "eb26f63f537836cc723fd7642f4c7eea6d0458e6deb77beb21525020304ec5da"
    sha256 cellar: :any_skip_relocation, big_sur:        "849ad406f701285061e2c7915e7b0b291646930debae31b169445c5bb2739bc3"
    sha256 cellar: :any_skip_relocation, catalina:       "90121b3f08f02b90f34d16459deaedffebfc9db59521d4987c31c3d3027c71e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf3fdf062b16b87f8232c28e02deea3376546f22422b077d65683c1cba8591af"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "avahi"
  end

  def install
    odie "Check if `llvm@15` dependency can be removed!" if build.stable? && version > "0.4.2"
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@15"].opt_lib

    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path.to_s if OS.mac?
    system "cargo", "install", "--no-default-features", "--features", "rodio-backend,with-dns-sd", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    Open3.popen3({ "RUST_LOG" => "DEBUG" }, bin"librespot", "-v") do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute_match "ERROR", line
          break if line.include?("Zeroconf server listening")
        end
      end
    ensure
      Process.kill("INT", wait_thr.pid)
    end
  end
end