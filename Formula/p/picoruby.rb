class Picoruby < Formula
  desc "Smallest Ruby implementation for microcontrollers"
  homepage "https://picoruby.org"
  url "https://github.com/picoruby/picoruby.git",
      tag:      "4.0.4",
      revision: "c4e8c3f8926b28faf297d982075721e64078dca0"
  license "MIT"
  head "https://github.com/picoruby/picoruby.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4ad68ab8e335970cd70e90c36a135ad5a25ffbb33697260dbc094c07df2e61f9"
    sha256 cellar: :any, arm64_tahoe:       "602d4390128c20360061053da9e4e99c517750eca9526e33962bbdad648723b6"
    sha256 cellar: :any, arm64_sequoia:     "453459ff68ab7709618ab14fe167e41f0b851b33253a4706677959d919fe8c68"
    sha256 cellar: :any, arm64_linux:       "aa3dbf4e408eebbfbdd9a93d5bc3e621fabc9a8a72efee7c6f32f3e3b26b1d1a"
    sha256 cellar: :any, x86_64_linux:      "166a9028b1ce88abcd6f629856fbda980b557c7f20043ffbc69dc0d2860ff384"
  end

  depends_on "ruby" => :build # for numbered block parameter `_1'
  depends_on "openssl@4"

  deny_network_access!

  def install
    ENV["MRUBY_CONFIG"] = buildpath/"build_config/default.rb"
    system "rake"
    bin.install Dir["build/host/bin/*"]
    lib.install Dir["build/host/lib/*"]
    include.install Dir["include/*"]
  end

  test do
    output = shell_output("#{bin}/picoruby -e \"puts 'Hello, PicoRuby!'\"")
    assert_match "Hello, PicoRuby!", output
  end
end