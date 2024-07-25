class Packetry < Formula
  desc "Fast, intuitive USB 2.0 protocol analysis application for use with Cynthion"
  homepage "https:github.comgreatscottgadgetspacketry"
  url "https:github.comgreatscottgadgetspacketryarchiverefstagsv0.1.0.tar.gz"
  sha256 "8d91ddc17883299f302752b12e11aa539c306304109d733c8863b7bc444c9629"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88a297481690251298b9a8ead058fee32a447386f55c4796d605199d30afd710"
    sha256 cellar: :any,                 arm64_ventura:  "247349ca46c1c3e5401b1db2d4dbc704b9ae316b7a35ed3da14e006128d6419d"
    sha256 cellar: :any,                 arm64_monterey: "4481780d380737b3f3ebc181c7ac1d2ffd94ef0e734e92c3a7008aae5a50f6e4"
    sha256 cellar: :any,                 sonoma:         "094f6852fbe16ccb0c6d18bfec1609c90272e389e443f270c24b6472d9e6a0a5"
    sha256 cellar: :any,                 ventura:        "02b09c6eb6719e36b804186378ca9e3221409283f477f6f03c7ccbb07e7cf977"
    sha256 cellar: :any,                 monterey:       "7d8b0975a480393e9e79c900d2b02296f10a412e3c9954a2b1b97105531e09b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "113a88db6097a15d3af6a4cc28a7f269f63093cc0e9b0130d35d739ebf017325"
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
    assert_match "Testing", shell_output("#{bin}packetry --test-cynthion", 101)
  end
end