class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.52.9.tar.gz"
  sha256 "f831e8be2524de2b47cb5ddf059573d9813625bb172de123e5a106d9f4d2f7ea"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52697577d90a9cea86cb2829c5a40a9388e5df727a8ee496ff7dad824e572142"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f64a4615f4bc08b5b00fc95ca746c910e66a612d04252a384a150ea4319b3fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74ee2483b087132a623c63ebe85c0650bd4a1f4ab4e12a592ffddfc93db0f9a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e55e58e59fd79c6adb7340dcc0a33fa6fc611a2375e22d6b7c90101ee1bd439"
    sha256 cellar: :any_skip_relocation, ventura:        "1ef2d7df464f3d8c3e0ae18c1901e595a52038ea6e55760f719e93df5c80d065"
    sha256 cellar: :any_skip_relocation, monterey:       "c4752c5c2908bbd592c845ced5910e31e4c5ccbfaf3d294d9a9468b9fd9b0d5d"
    sha256                               x86_64_linux:   "4e5d1239be58399f35ddc87bbe123a435f27fbc537e0b4cb52a23b33316e3fa4"
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