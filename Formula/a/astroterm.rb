class Astroterm < Formula
  desc "Planetarium for your terminal"
  homepage "https:github.comda-luceastroterm"
  url "https:github.comda-luceastrotermarchiverefstagsv1.0.6.tar.gz"
  sha256 "144ad050a4ca3840d321bb0e454cefbfee78f2b85a2e5add154ef4c49e984d86"
  license "MIT"
  head "https:github.comda-luceastroterm.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "036452503726262a378258524100a05b94e707cf5da53ff02cfe2f13877eb651"
    sha256 cellar: :any,                 arm64_sonoma:  "604d56382ab8b716235ffb58fc9b72c1f7698ed7a303fde3907e8885973d6639"
    sha256 cellar: :any,                 arm64_ventura: "4fd420c68e227aa7cf752508342e103efe42ad1b9f366e1675157dc467c8a700"
    sha256 cellar: :any,                 sonoma:        "9be14e54e27d8837276013b70ee461c81d445ebee9ec6b50bc44810d0b372e12"
    sha256 cellar: :any,                 ventura:       "01a5b1c28c12ca3e6d7feb3733d0c13500d11c452928846ae57e3fa83164e299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a11eedf6721ddd00da0341ca160c8e77676d4f1ee4773cec91dbdfdeeafb8a11"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "argtable3"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "ncurses"

  resource "bsc5" do
    url "http:tdc-www.harvard.educatalogsBSC5", using: :nounzip
    sha256 "e471d02eaf4eecb61c12f879a1cb6432ba9d7b68a9a8c5654a1eb42a0c8cc340"
  end

  def install
    resource("bsc5").stage do
      (buildpath"data").install "BSC5"
      mv buildpath"dataBSC5", buildpath"databsc5" if OS.linux?
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # astroterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}astroterm --version")
  end
end