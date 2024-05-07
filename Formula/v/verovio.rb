class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https:www.verovio.org"
  url "https:github.comrism-digitalverovioarchiverefstagsversion-4.2.0.tar.gz"
  sha256 "7b399635e86af12200e76cdafc0417f8ee35c5f34b1e913da0af88fc752254fc"
  license "LGPL-3.0-only"
  head "https:github.comrism-digitalverovio.git", branch: "develop"

  bottle do
    sha256 arm64_sonoma:   "4d2431269e458eb6bf591c61f9d78c32012a37276c8c3804ec84b90b2ec828ed"
    sha256 arm64_ventura:  "45fece648c9d67ac406e25b2c0eeef6ad8f2c6161ceb1a33ad8db65acdea421f"
    sha256 arm64_monterey: "c0096c6df70559565b94e33379367adc3c5fb3d9b9399a99ea716ea1e4676bc1"
    sha256 sonoma:         "b79c9cd9790b9b6d5fdd56b038f78e2264019c87e9d5ef9a43ffadabb8d5a8db"
    sha256 ventura:        "eefedcafbeaf6c5b82a23bf60a526412bb08bdc8d7206f16c0c2bf82b9f0c992"
    sha256 monterey:       "61a2bc73d27c85e1d244b7f26a06a3598f81d0c996770978f6a067a10bd4d98f"
    sha256 x86_64_linux:   "ccc5aefc41f5285cc65e0e890193131151208f60f8a1d9752beb542c505d396c"
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