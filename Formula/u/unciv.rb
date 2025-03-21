class Unciv < Formula
  desc "Open-source AndroidDesktop remake of Civ V"
  homepage "https:github.comyairm210Unciv"
  url "https:github.comyairm210Uncivreleasesdownload4.15.18Unciv.jar"
  sha256 "f3231ccf8f797f0b731a0a2fdce68ec15c3869d1b049fa4f90ddc8cfaf53611d"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c44d5d6c05cb25041b6c0baaeccc2944057bb20eac7bf97af0254e4af2b82c0"
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