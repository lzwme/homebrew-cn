class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.51.0.tar.gz"
  sha256 "7075c054014666fb5cc60c67b9dbb6cd3f79e2558804b9725be9467b2db23c46"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee73c45f98ffb73cbbedb6ec6c28ce85915986c8b02acae14b67f715ce9d64a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8140e152ee1c92b2c6b2650ecc641c2262ef98763e5b7c592a87c8283f287522"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b1186f1c8b2b36ac5dafb3ffbf61d0f23cfd0052bf07716acdcdc1301e82aad"
    sha256 cellar: :any_skip_relocation, ventura:        "c336a1a2f287d3339aaad494935a3ea4e741374221dbf8b428d167bc71eafc7a"
    sha256 cellar: :any_skip_relocation, monterey:       "16e3b83ebf3306a189bdd16049f7f44a1867143096bd23a014a838cf2d8a88ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8dd73651d58d7393032f4314a0ae76130d94452c9c63b79ee23766d5be682db"
    sha256                               x86_64_linux:   "b74af6681ce0f413f95eaf20893befe68fcb82ce84161916f52066308b49df8d"
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