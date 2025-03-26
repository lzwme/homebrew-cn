class Unciv < Formula
  desc "Open-source AndroidDesktop remake of Civ V"
  homepage "https:github.comyairm210Unciv"
  url "https:github.comyairm210Uncivreleasesdownload4.15.19Unciv.jar"
  sha256 "fe26bedb08a83e1737d09ec3ace75ef6476c907ad0e8c658d79c21c6095b5a9a"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "21cada6bef8e35e379d3d50625eb0a1c774ce1bf7c6d373a6d7fe33794b02559"
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