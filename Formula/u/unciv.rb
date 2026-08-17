class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://ghfast.top/https://github.com/yairm210/Unciv/releases/download/4.21.9/Unciv.jar"
  sha256 "97dbe021662dff9512f40939d4581d4c1eab0781eab0b957c2dc79861fe73ed1"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2bdd55ff4dc35ff0acfd7dda5c430b4383d2cf7648ab33f01a8012419f22809"
  end

  depends_on "openjdk"

  def install
    libexec.install "Unciv.jar"
    bin.write_jar_script libexec/"Unciv.jar", "unciv"
  end

  test do
    # Unciv is a GUI application, so there is no cli functionality to test
    assert_match version.to_str, shell_output("#{bin}/unciv --version")
  end
end