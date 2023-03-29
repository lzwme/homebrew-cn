class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.51.3.tar.gz"
  sha256 "4e3fad0c0035799b06c20dd37552a3d38b2077f243dfeb50dd7d84a8c173a990"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a2ca9746cada0d18f59c3f20b922fb59814ba3eb65df2656466f1fd2c93a4f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b8921528bfb310017e3e212053182622fdf1d5caa1a69a9091331e3f626b7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0994f1fb3bc0b9ae6da2c7480a98ca9ac6c06bab05a8323c5d25635cb45ba31"
    sha256 cellar: :any_skip_relocation, ventura:        "8520138c36f2767d860c5252d12f142becbacdf6b5787784626d02c3251f8c5a"
    sha256 cellar: :any_skip_relocation, monterey:       "7e410de127bcf8e3812d4966859193bab4f79c885ceaeab442a4e004bfdf6464"
    sha256 cellar: :any_skip_relocation, big_sur:        "feecc6f5dee334e295ed2dcee76bc12cbe344927671a50b7adf0e7896dedeb52"
    sha256                               x86_64_linux:   "d5dbc354968a6d956bcd6812b930a57c7338a51a043a4e5c00034613d3e72de0"
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