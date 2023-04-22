class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://ghproxy.com/https://github.com/iBotPeaches/Apktool/releases/download/v2.7.0/apktool_2.7.0.jar"
  sha256 "c11b5eb518d9ac2ab18e959cbe087499079072b04d567cdcae5ceb447f9a7e7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0dc361a605644f6b294e767fe30b7c47812222b344e8e6b1a9780f3251170291"
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