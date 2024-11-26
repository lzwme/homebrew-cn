class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https:www.verovio.org"
  url "https:github.comrism-digitalverovioarchiverefstagsversion-4.4.0.tar.gz"
  sha256 "4c0cd2120625c709bdd0658470b53e9e1241f3c6525df7904ed7bdfb2f11cdfd"
  license "LGPL-3.0-only"
  head "https:github.comrism-digitalverovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "a19a81a21d33b1053607f58f117fa9f258c7fb36fc960c4f5a9f672c8412e029"
    sha256 arm64_sonoma:  "3a90e3b5acc6a4e26426cd228b22f8382a992353d4265ee855a6c05142b050da"
    sha256 arm64_ventura: "b7b51c01ad9b888b2f3dc69df371543b60b1a68dd56079bd77082938e74d09c6"
    sha256 sonoma:        "f43d67c645742be4dc9c01157a94e6b148ebcb3e096c20a3f1c2c6d64f304ed8"
    sha256 ventura:       "970acf1db4ce1050fc27b6fb1af446ee9e5041a54c258f2b137670666dadc488"
    sha256 x86_64_linux:  "b16c478b74599b28dda3ac7a710ed706b755b9a24fff499d316ffe54e421138e"
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