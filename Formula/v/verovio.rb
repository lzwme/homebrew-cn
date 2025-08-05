class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://ghfast.top/https://github.com/rism-digital/verovio/archive/refs/tags/version-5.5.0.tar.gz"
  sha256 "6916b0c379f99070b8db3d18df0093db33beec4cea58dbdc3f802a19a6646601"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "a7798191daf149da2580d1101f63009d0edfbfe1539ae120748d49d02ade2911"
    sha256 arm64_sonoma:  "dcebd8a5996031be1e88a6b21c45bbc4afd59f6df69d3f966894295fc4891c1b"
    sha256 arm64_ventura: "636a1f1353e437b2cfd910c6949058e0eb1a9135d6006c15c3c13daf8e98f83e"
    sha256 sonoma:        "36833053bbe3ba97ddf63c2047a19a4b7057699198c9df2c6f86b5d93e549ac5"
    sha256 ventura:       "26e427f8323ccd578c1cca43544e368d71b405c87da4060d2479822e47d98e71"
    sha256 arm64_linux:   "4cf3e204e8e621870ca66f58e41513e7a4f314a279e2978ba19bd0e190e53b8c"
    sha256 x86_64_linux:  "3b672c7cf0e6dadcb71ab90cc80cbf577f3eaa4869aace6fdb44d93da0fe0391"
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