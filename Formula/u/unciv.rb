class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://ghfast.top/https://github.com/yairm210/Unciv/releases/download/4.19.10/Unciv.jar"
  sha256 "e32d6db00ca89a3ca027e0f0702006f1f8842258d59b5e7da94fd8fa47e44a17"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f31f0a836d60faa967d29d2b3a5585b0a804dca006e7cab473e01aab475f1e5"
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