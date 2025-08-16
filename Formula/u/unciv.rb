class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://ghfast.top/https://github.com/yairm210/Unciv/releases/download/4.17.14/Unciv.jar"
  sha256 "76cc529c26d71241e22b7e0b6135dc5a4cd784964bb2ff4270450085588f8865"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89e7ebabd9737604d5b53f5706ab16447aa9bd1972b082ef103736ab6867a336"
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