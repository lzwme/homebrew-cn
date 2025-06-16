class Unciv < Formula
  desc "Open-source AndroidDesktop remake of Civ V"
  homepage "https:github.comyairm210Unciv"
  url "https:github.comyairm210Uncivreleasesdownload4.16.16Unciv.jar"
  sha256 "1dbe017ed6588531a9fb674e9d8676b5cbf4b88e386d609515e2ff1a9a3cd74e"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9308e3d1e64573348b4bebf43673f751f4d430b027b3206bdd58b138e387c766"
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