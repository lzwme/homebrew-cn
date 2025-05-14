class Unciv < Formula
  desc "Open-source AndroidDesktop remake of Civ V"
  homepage "https:github.comyairm210Unciv"
  url "https:github.comyairm210Uncivreleasesdownload4.16.9Unciv.jar"
  sha256 "49acdf96f5bd0333992a0c55d309a5a890d1f74ffd7bed3d7a979f9e80e43e23"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7f78a7d0b568cfae93571e9dec960abd6ffe6dae8315b3be222d5bd30022c3a0"
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