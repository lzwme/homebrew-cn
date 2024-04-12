class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.53.6.tar.gz"
  sha256 "174076d7e9ba73a17e756e4e2b384b721ac83d45ca614d997892b8214b11e817"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e60e1f2d393f781463d92cb3d16bb355f26a320f4dc45dfde1a043e76471f2fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd4998a8e1b81a1bb57acb060b3e5604df0ab860f40d4f36d954ebe7d2723583"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0343e8341ee4860a9b205a922b92d64832565537a6fc313fc3a30d1324309491"
    sha256 cellar: :any_skip_relocation, sonoma:         "946b624e85fd04570027e87931fb98b01a7a7083f89ea9366a045960ea365083"
    sha256 cellar: :any_skip_relocation, ventura:        "e0bcacaa10913e8202d6e83ec39412efc89fd1ba097c48990e0ad6aebc50e75b"
    sha256 cellar: :any_skip_relocation, monterey:       "52aa07f0274d1e8357aee59631ca5b3b7c5724c949fc9c0ed8f906739290c73c"
    sha256                               x86_64_linux:   "d9526c219d6ffe28956abfea0e6d96483d2e85830358e2b9687368015df03e1c"
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