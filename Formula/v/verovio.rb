class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://ghfast.top/https://github.com/rism-digital/verovio/archive/refs/tags/version-5.5.1.tar.gz"
  sha256 "e27deafa8ae07052649a85478a1476aa83dcf69bb0b84280c5fa3d810d5f2360"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "3d3796f68feade29095d8c4c45b5998c31ad98c7cba30a66d910a2f344e151b0"
    sha256 arm64_sonoma:  "9f16706f8f9395fb519b70bc4d18bb0f8f45c03f5d2c9f22b989ab8101049671"
    sha256 arm64_ventura: "e9159f02e84ad51de2fde5c71b14edb4ed5530233b13cedab521a10e4bf65666"
    sha256 sonoma:        "80b80545444e525cd400ef7b2c311eb1fb9170679af06ce7010f25dd0ed4aa57"
    sha256 ventura:       "04421d7d16c8dbf81425f9b6e657903f516d1089e4ca7a2b05c1b0e76137154f"
    sha256 arm64_linux:   "05fef89e4f3e58aba53398dd4306a84cf695505b4afef6ec92d5a599757ff7cc"
    sha256 x86_64_linux:  "44d2407100df20032a8c089476cb1b86b59d8212f132eac57909375417f06158"
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