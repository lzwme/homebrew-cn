class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://ghfast.top/https://github.com/rism-digital/verovio/archive/refs/tags/version-5.4.0.tar.gz"
  sha256 "212227339a069770a4daa06aee4b9c36dff3633ca709582d3da3e710ee451955"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "69e863c01f446773608f294c36b86f96ec38a234b72b95292214152e88466e61"
    sha256 arm64_sonoma:  "7810a88e102bbe35a1f828be1af00c360298f0ffdf61244c66bf007bb8f4be1c"
    sha256 arm64_ventura: "e72169acd68cd39094c3bdb8ed10d5ba4286ac9cedf0f6d594b6e0524f8f7a49"
    sha256 sonoma:        "516eaf5368ade524de9725eed4ce2b3ba838cb2c528dba0781d1dcc221debcf1"
    sha256 ventura:       "b4e6ddcddc21f16a219e454e868ee5665201cbf736bfd4c3875ea1671c9f7e8a"
    sha256 arm64_linux:   "73ea76ae63ce78a4e018cfab702f9d87015ee9bc2b398613232d069e48dda435"
    sha256 x86_64_linux:  "f2385acb2fc0134602722596b9934581ea00a22403d8d2662024bd119554c323"
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