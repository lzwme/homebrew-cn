class Unciv < Formula
  desc "Open-source AndroidDesktop remake of Civ V"
  homepage "https:github.comyairm210Unciv"
  url "https:github.comyairm210Uncivreleasesdownload4.16.10Unciv.jar"
  sha256 "229f0b6311c890808904a34417de7a6e1360b5318feb4589c866f2877e9ccb34"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9673e86d2a9b3f60d89357e2d58cc087ed2f5758375beea550bcc8deefb30581"
  end

  depends_on "openjdk"

  def install
    libexec.install "Unciv.jar"
    bin.write_jar_script libexec"Unciv.jar", "unciv"
  end

  test do
    # Unciv is a GUI application, so there is no cli functionality to test
    assert_match version.to_str, shell_output("#{bin}unciv --version")
  end
end