class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https:www.verovio.org"
  url "https:github.comrism-digitalverovioarchiverefstagsversion-5.3.1.tar.gz"
  sha256 "4a5801dbae44c4bf5c44bb12ff35a32d3615d9956927830365005b54b31806fe"
  license "LGPL-3.0-only"
  head "https:github.comrism-digitalverovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "68b6a19e0eadd71ab03533166b625ee2fb0610b3c9dcae66a04c3e62a809fd00"
    sha256 arm64_sonoma:  "860e397f79d84af6baa3d8359e072b9157fc514fc01394dc44750e40f13b15cf"
    sha256 arm64_ventura: "414f63e9a2346a0027b38dd057859f199b5f636b09999db91fc12130ecc50553"
    sha256 sonoma:        "2a1a3f1b1ac48f7f865290acb2708e4b9128473cecda51c14f52546efee7433e"
    sha256 ventura:       "67707c4211e7fb093b3d4a23cad663518d15a65db2ea4a5d9eb4ff816ca70861"
    sha256 arm64_linux:   "bdea8e1f64f3ac1e8f209c0c4fd1fed38b323fd1414da352a28ce5c8794b8db6"
    sha256 x86_64_linux:  "5e2829d66b33df0f3548bdba5f9e6a200abd82469fe7fb310d7652f6526773d1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    resource "homebrew-testdata" do
      url "https:www.verovio.orgexamplesdownloadsAhle_Jesu_meines_Herzens_Freud.mei"
      sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
    end

    system bin"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}output.svg")
    end
    assert_path_exists testpath"output.svg"
  end
end