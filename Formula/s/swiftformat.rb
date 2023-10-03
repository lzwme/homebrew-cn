class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.52.6.tar.gz"
  sha256 "8c06c130021ef7941bf812b137be1ac392dbadee3344d9461d90820c053708b7"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49bb393656ed2bae46895bde289d02112a92652a45a5f4bdec907127fdc3185d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4667d2b4bd841157acaef6192668815288c62b5a6e97defc987f4065cdc9e77a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efcc1da420c009a84f3941452612a13a2383f67a362016277c6a6bf70b138d0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "589acbdb87473c55008c6d2a980a1a1b553fd84b0e3b41b9c0df0202b94366b8"
    sha256 cellar: :any_skip_relocation, ventura:        "684013a07c5dc45f302ee4250858381217a90df89a3e5fe48776778e0e49390d"
    sha256 cellar: :any_skip_relocation, monterey:       "3b4f9abfee81b9012731f96542a7451d5862286fa9f5edbfce04818d1169ddd1"
    sha256                               x86_64_linux:   "b0956378840dd6043e35c25aa50fabfd9ac51690345b15b9ec52c3a4909ae228"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end