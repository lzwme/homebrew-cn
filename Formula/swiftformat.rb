class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.51.5.tar.gz"
  sha256 "1c4038e3cc9589f4d5f05c50f4be7d64d044c0cd75d7e2c09b032fdb8bff1152"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80a7dd997ba717f675f72a1c98d15ed5849ef664c3a240ad104997ae4e9ccb41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76206984febe52759ac0ee47d1ffc196aec158021c680a901a040b4c544a2289"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9395b94db2479bf606b37f74446b546c6c7c3578e2d9019c11365c0af28f1b72"
    sha256 cellar: :any_skip_relocation, ventura:        "378c59a03d0f39d1ba24013a7dc49fd1c8f397ece3ac6610b49f313d5636026f"
    sha256 cellar: :any_skip_relocation, monterey:       "2f5e55248cbab4bc8b7499c4875e2bfee5684bbe92560ba99e6629aa664516cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6f79e3e46151f63cba385848f89ca7aa50560758dfaf86d1a7bd143bf4032d3"
    sha256                               x86_64_linux:   "fff4a621e20891f3dd689d85910d63351c1204ad713fbb5318586f4f929d1b7c"
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