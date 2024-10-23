class Packetry < Formula
  desc "Fast, intuitive USB 2.0 protocol analysis application for use with Cynthion"
  homepage "https:github.comgreatscottgadgetspacketry"
  url "https:github.comgreatscottgadgetspacketryarchiverefstagsv0.3.0.tar.gz"
  sha256 "dfb25d42288a20f1377624736da3199214ca89d1f85029b9fd8ac7b4060c3de0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4350ea8867c8f2feea2d41f68f2b741b3f18d32c3381b4abeed57c488c741084"
    sha256 cellar: :any,                 arm64_sonoma:  "466b9385c055dc9dcadfbfbb22bb1fdc5df9c65dbafb03d4f4fff57b4467faba"
    sha256 cellar: :any,                 arm64_ventura: "c49c3db0dad1b457096bd6d5861f8bc90c22618bd14a6f17ec7fdcdb095d65d1"
    sha256 cellar: :any,                 sonoma:        "8bc540cd04ed99f989671a2459225d36889c68d6af04a9e0fafa24cd68c4e368"
    sha256 cellar: :any,                 ventura:       "09018cd616ad904ad97285d403771486fde01ef30012a120cf00fc108dd9d108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae955238f9298dd121de5a8de6b431f06bdae5987c1b4545d570e4aae44ff8f"
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
    assert_match "Test failed: No Cynthion devices found", output
  end
end