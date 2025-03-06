class Unciv < Formula
  desc "Open-source AndroidDesktop remake of Civ V"
  homepage "https:github.comyairm210Unciv"
  url "https:github.comyairm210Uncivreleasesdownload4.15.14Unciv.jar"
  sha256 "23ba482998b212579f53f677e014fc12cd7b9fa8fe3ffb6c4dbe9a03fcf1be6c"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cc59207c5c11d4f31a168392e0e377bc66675ffb7db83c07aad3630dd63ee7e"
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