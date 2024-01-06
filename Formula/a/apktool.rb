class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https:github.comiBotPeachesApktool"
  url "https:github.comiBotPeachesApktoolreleasesdownloadv2.9.2apktool_2.9.2.jar"
  sha256 "831f0ffc97b6f20f511d6183cbf6785464d341aacb0fb7e6f22ef0c7b228911a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a18b386d6b24a646f03b912148ec8c6de10e5e1e862e9fe19604a779b59f45a1"
  end

  depends_on "openjdk"

  resource "homebrew-test.apk" do
    url "https:raw.githubusercontent.comfacebookredexfa32d542d4074dbd485584413d69ea0c9c3cbc98testinstrredex-test.apk"
    sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
  end

  def install
    libexec.install "apktool_#{version}.jar"
    bin.write_jar_script libexec"apktool_#{version}.jar", "apktool"
  end

  test do
    resource("homebrew-test.apk").stage do
      system bin"apktool", "d", "redex-test.apk"
      system bin"apktool", "b", "redex-test"
    end
  end
end