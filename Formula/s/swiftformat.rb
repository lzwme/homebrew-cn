class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.53.10.tar.gz"
  sha256 "0bc66db7263aefdb839628d91996209f55f4b378221e7bfbc7467a74059335fa"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07a24ab550f0a4b26168b77c14b3b184e97552eb9071723af1103b1ff8d38bfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2781c7eb35cfe585ae8a5f41395694e67af26c5725d25d08530a4f6adb191842"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be39b5733c7a181931682200f3fbece32146b84b7098fec1d9f4d22d248a91e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a080392954a019c55552ca7c6ab56033e8ab6aa1a598a0015b80ee12c62a4414"
    sha256 cellar: :any_skip_relocation, ventura:        "7a5cc00008a574bcc3f94c8048fe058a4211a1f2952b65051a723212c07d8ce5"
    sha256 cellar: :any_skip_relocation, monterey:       "60b9451e66902de3233febbf20cfa3df39304fb329eb478a8cab277874da7869"
    sha256                               x86_64_linux:   "d4bacdce7d4de2ca8e026577a94e87828038d25c28235a96f740fee46c317798"
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
    system "#{bin}swiftformat", "#{testpath}potato.swift"
  end
end