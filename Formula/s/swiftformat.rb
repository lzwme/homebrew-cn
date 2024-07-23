class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.54.2.tar.gz"
  sha256 "966084e04b25a921cc3006ca75caccadb6566e24713e75cc40d7302d2ed26278"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81df298cd70628b2149823fa370aa3a6799fa3d794e1541f76f3f4a2d7bedac1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c69312fea87da1123deb27e6943e90affe661475571c6ca5967321688b46df8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da2a5c24a8132589cee415f4a0754ccc8b39e67e74e06469a3cb6b45d880877a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d5e97425579868571f6322c7472793ef0e652b0ccb64248a466f5f6a85d8b0c"
    sha256 cellar: :any_skip_relocation, ventura:        "402e0e5e117296bee234ef2d657a49ef3397dd898db244a43abe6b02b83b6c48"
    sha256 cellar: :any_skip_relocation, monterey:       "67abaff7e1f041b060e35e8ad1573737c93866c18a9bb4e84c9fd1d85e2064f2"
    sha256                               x86_64_linux:   "5c6a46f3995ad0b606c0c8a823b9236998ac512ba8895e8b1c3b35730fc2067d"
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