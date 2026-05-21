class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://ghfast.top/https://github.com/rism-digital/verovio/archive/refs/tags/version-6.2.0.tar.gz"
  sha256 "b988719a1921a302bc7cd65ec736852cf088dfbda8dd1503f25be99707daf540"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "0c43748b191a3cb1f1f9922d4184296fd1488fb459109390b39b9d2d0cd5d04f"
    sha256 arm64_sequoia: "d350a6a5df8a5967523069cc9e7060daebc98ea243cad63da912d5a3217f3a64"
    sha256 arm64_sonoma:  "772abf2b72c3c294e035a3b34d56b47917f10cb2951b7228e5161bec0164afa1"
    sha256 sonoma:        "8ca34e23b878ea9369617db4d8871c2c8fdd330f53541156639a5f2503d3a451"
    sha256 arm64_linux:   "8121273c98da1a52e82972e392905a1c9c5c9e359a42dbf8409162bbaa3de3ba"
    sha256 x86_64_linux:  "c3d44f0c930a79f0429a014bc971049b4350d09b86c11817a694c0e9c345c87f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "./cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    resource "homebrew-testdata" do
      url "https://www.verovio.org/examples/downloads/Ahle_Jesu_meines_Herzens_Freud.mei"
      sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
    end

    system bin/"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}/verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}/output.svg")
    end
    assert_path_exists testpath/"output.svg"
  end
end