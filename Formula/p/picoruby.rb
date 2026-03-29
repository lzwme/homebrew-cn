class Picoruby < Formula
  desc "Smallest Ruby implementation for microcontrollers"
  homepage "https://picoruby.org"
  url "https://github.com/picoruby/picoruby.git",
      tag:      "3.4.1",
      revision: "d437873d68a6ce0f8ff6256702ac149b8e94a05a"
  license "MIT"
  head "https://github.com/picoruby/picoruby.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "072f3b80d431ea8cbae695f3e5d8e3e35c970bb2c76aba437b83cd2025093eba"
    sha256 cellar: :any,                 arm64_sequoia: "7bfce9ade4be270fb2878db27195f0b855d0f6539bc7c01515de59c80aef31ec"
    sha256 cellar: :any,                 arm64_sonoma:  "9100c7ff0fda4e7ec6463cecfd32f7e362e17285980966198c1efdb5d1bb2876"
    sha256 cellar: :any,                 sonoma:        "4bc89e66812ecc7f58cd277704f4d13d32784db67e6e6bb42b3215011cb861d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "924e8aa6e4438ea1230cb0386ec515535c83d1c5e5634cb7c52144a688510eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6144b5dd2230f88151c7e508ed99ce4abc310e339bb0d10c007644f13852b5ec"
  end

  depends_on "ruby" => :build # for numbered block parameter `_1'
  depends_on "openssl@3"

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