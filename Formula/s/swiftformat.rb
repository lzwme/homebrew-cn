class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.54.4.tar.gz"
  sha256 "463752da6546c175645638bbe1496f99b4c82b858baa54ae1418ce921b4c534b"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cdde6cd2cbf9fd0eadcf905c4f156fea2756a34848bd1418ffbe3dc62d755b0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00038c8d5d4f8ef45dc289f0cf4f4fc57400277a763720ab72218895bc167c5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "379134624948a744491f6d00f89fb730fd0383fd02721b4efd0f8e9383220d38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "116a222e9b31839efcc8fedc7b3ea3edf1dd727d0f2c08c0c0d9fec22994f3d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "383c3a96585c916302a40d273ca3acc8298bd02ed671961890feae94801828c8"
    sha256 cellar: :any_skip_relocation, ventura:        "780b5303f448b780f1a8070631ec536048df5d34ab13298c087c84c71cd85496"
    sha256 cellar: :any_skip_relocation, monterey:       "16a35c0886339d9c29909e63803434380164f6077b594f832854fdbe605c6d97"
    sha256                               x86_64_linux:   "e78e867a651c28d509f1842e8eb2ae905a1f4ee7d5070d21236a2bde4107cef3"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleaseswiftformat"
  end

  test do
    (testpath"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system bin"swiftformat", "#{testpath}potato.swift"
  end
end