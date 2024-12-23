class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https:www.verovio.org"
  url "https:github.comrism-digitalverovioarchiverefstagsversion-4.5.0.tar.gz"
  sha256 "031809b0f82588e7bbf0b2ac78818efde6b754d77e68752713f2b090e1084a6c"
  license "LGPL-3.0-only"
  head "https:github.comrism-digitalverovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "747f3ed29e5c06ea2f3081dc54b87d2cda1536cab11c2a09000e461dc98cac67"
    sha256 arm64_sonoma:  "44dc546eabe50efb6213bceb731a07948e22fa5f4617cb9eb1cc0d59023eaffc"
    sha256 arm64_ventura: "74e010cae2f02743ef63bb7fb291ba1b102050700a838a4850b19593982d48d3"
    sha256 sonoma:        "ea91768b60fcbc99ffd5b6592de14c5e3f930dd7c98e88d960f3b9ac2c1e562c"
    sha256 ventura:       "a545153e3bb673f7a2586c221a060a6aff0ce96d150af2a04f854d148c69045e"
    sha256 x86_64_linux:  "3913eeb7e774b1fe18a957a28b630e2f2164f112492eab526f3e5f122f4a17ab"
  end

  depends_on "cmake" => :build

  resource "homebrew-testdata" do
    url "https:www.verovio.orgexamplesdownloadsAhle_Jesu_meines_Herzens_Freud.mei"
    sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
  end

  def install
    system "cmake", "-S", ".cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    system bin"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}output.svg")
    end
    assert_predicate testpath"output.svg", :exist?
  end
end