class Packetry < Formula
  desc "Fast, intuitive USB 2.0 protocol analysis application for use with Cynthion"
  homepage "https:github.comgreatscottgadgetspacketry"
  url "https:github.comgreatscottgadgetspacketryarchiverefstagsv0.2.0.tar.gz"
  sha256 "9930e39638df4210710859e7e91b63a5d0197c4d7f52f81457f19bbb08fe446b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fc3297cdbc4efd4a7c10a3ce49550cb035ba338fa2415aa00ac925f65cbbbad8"
    sha256 cellar: :any,                 arm64_ventura:  "b3b6bd2022078c88251a4e453fcb59640cdb0402a04152e251ca81f80e84e41b"
    sha256 cellar: :any,                 arm64_monterey: "3b937a60e201f2711eb969105d92c5d4a8d36414c5126bc2d67d91b33a419072"
    sha256 cellar: :any,                 sonoma:         "8d350282a9572e872d1656d9ad3c85fe3789ef1c96e9e8e0f4582d52ec7f5d79"
    sha256 cellar: :any,                 ventura:        "117654989844967b2e063bfed466f86512e8c498dc545432a72966004195bf73"
    sha256 cellar: :any,                 monterey:       "086d00757d113fba498a8ddda937986e910ee814de22ebf9350ecf52a866c55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7960e070d4379dee4be02fc0bcb833848f07909ee825ac4aebd9b450ad38dd94"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}packetry --version")

    # Expected result is panic because Cynthion is not connected via USB.
    output = shell_output("#{bin}packetry --test-cynthion 2>&1", 1)
    assert_match "Test failed: No usable analyzer found", output
  end
end