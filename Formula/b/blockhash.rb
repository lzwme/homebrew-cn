class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https:github.comcommonsmachineryblockhash"
  url "https:github.comcommonsmachineryblockhasharchiverefstagsv0.3.3.tar.gz"
  sha256 "3c48af7bdb1f673b2f3c9f8c0bfa9107a7019b54ac3b4e30964bc0707debdd3a"
  license "MIT"
  revision 3
  head "https:github.comcommonsmachineryblockhash.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a061ae502980fe5b75db2a6422c83553023f54e6c607f34fbf90e18b7deeae6b"
    sha256 cellar: :any,                 arm64_sonoma:  "ad0948909b8cb2a9e7a365e66c5d01a791bd46c147f8e02a21cf9f6d786759fc"
    sha256 cellar: :any,                 arm64_ventura: "d43417f1103c71f1c80194f0382e6fa3763b306f3a1f8c079fa7a37985982c87"
    sha256 cellar: :any,                 sonoma:        "46b8a75c780da4f05c9ba78d7d0ebdfdc96d722dd8acdad98009f0dc4a3314c5"
    sha256 cellar: :any,                 ventura:       "d62ad2a55acdcded11d4a6a9494da14efb0621212a4b5cef59b09f9b2478a6bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c102648f2c4bfcf200f347c0279f666d51135268f76065fd358bbd05c3d1ac"
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick"

  uses_from_macos "python" => :build

  resource "homebrew-testdata" do
    url "https:raw.githubusercontent.comcommonsmachineryblockhashce08b465b658c4e886d49ec33361cee767f86db6testdataclipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    system "python3", ".waf", "configure", "--prefix=#{prefix}"
    # pkg-config adds -fopenmp flag during configuring
    # This fails the build on system clang, and OpenMP is not used in blockhash
    inreplace "buildc4che_cache.py", "-fopenmp", ""
    system "python3", ".waf"
    system "python3", ".waf", "install"
  end

  test do
    resource("homebrew-testdata").stage testpath
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}blockhash #{testpath}clipper_ship.jpg")
    assert_match hash, result
  end
end