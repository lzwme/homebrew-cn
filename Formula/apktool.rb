class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://ghproxy.com/https://github.com/iBotPeaches/Apktool/releases/download/v2.8.0/apktool_2.8.0.jar"
  sha256 "b331323ebf325d63e13375a6147915f9dac048f0f1f86783806f925941748dbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4b0afa7dba8a33808ccc5be2d637548bd68e0f9597587b966325f8e4d0de3f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4b0afa7dba8a33808ccc5be2d637548bd68e0f9597587b966325f8e4d0de3f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4b0afa7dba8a33808ccc5be2d637548bd68e0f9597587b966325f8e4d0de3f8"
    sha256 cellar: :any_skip_relocation, ventura:        "a4b0afa7dba8a33808ccc5be2d637548bd68e0f9597587b966325f8e4d0de3f8"
    sha256 cellar: :any_skip_relocation, monterey:       "a4b0afa7dba8a33808ccc5be2d637548bd68e0f9597587b966325f8e4d0de3f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4b0afa7dba8a33808ccc5be2d637548bd68e0f9597587b966325f8e4d0de3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33c3905b48bc2325fa570b910bb8a4459e82ac0e8496ad7785629b514435d6bf"
  end

  depends_on "openjdk"

  resource "homebrew-test.apk" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
    sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
  end

  def install
    libexec.install "apktool_#{version}.jar"
    bin.write_jar_script libexec/"apktool_#{version}.jar", "apktool"
  end

  test do
    resource("homebrew-test.apk").stage do
      system bin/"apktool", "d", "redex-test.apk"
      system bin/"apktool", "b", "redex-test"
    end
  end
end