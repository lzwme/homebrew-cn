class Picoruby < Formula
  desc "Smallest Ruby implementation for microcontrollers"
  homepage "https://picoruby.org"
  url "https://github.com/picoruby/picoruby.git",
      tag:      "3.4.4",
      revision: "8d1f2251f700a7077165809d3f959b7d9d85530b"
  license "MIT"
  head "https://github.com/picoruby/picoruby.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1fbdf771ceda0116c132d59af793a03baa5a7796a43d075137ac4e86ad240774"
    sha256 cellar: :any,                 arm64_sequoia: "e3746ebdb648302c183f6730f9628aa709658fa6d8b7794e5f2f504bb43ac54d"
    sha256 cellar: :any,                 arm64_sonoma:  "dee2fbf83b8675e1d431b1ee22a5db101b5b6962c22af11918cf928499a1968f"
    sha256 cellar: :any,                 sonoma:        "4a41fbd330e87582e8529d794938b55edece9c363e4e00913256f07bbf74b8b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd4e3a6339540ee98447310251f1027a5f4baa99a7258f63867db2265c03056e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff983804e2b31d7de386413510a082e2929ee2bc1aad982dd34178df243eeb96"
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