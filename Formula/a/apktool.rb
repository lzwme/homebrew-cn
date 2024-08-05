class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https:github.comiBotPeachesApktool"
  url "https:github.comiBotPeachesApktoolreleasesdownloadv2.9.3apktool_2.9.3.jar"
  sha256 "7956eb04194300ce0d0a84ad18771eebc94b89fb8d1ddcce8ea4c056818646f4"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b07818b777c81f1357006c19bdfdf594e79ad11ee3fcb793eed617a6976920e2"
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