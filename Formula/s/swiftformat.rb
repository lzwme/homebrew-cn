class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.58.4.tar.gz"
  sha256 "95cd93f01d84206dede9e39333c45a05a024a2a3e9438e911b1e42aab6b7de12"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "587f9bbf5a001483e68fdbf8ee47bc57832e0d3d3bc904d6150916caa796d3d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2824ded932361df2f02d2865d90b1ac220ae5953145600f4004034a97632ff93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ce256b9ceddb22eb81657b6114f35a15a6f8474490af06ab613c46adc62347b"
    sha256 cellar: :any_skip_relocation, sonoma:        "beb747a0e51406eff421c42284158dcf8fabea19d95b925480ba6816acdb9d7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33c0ac17dcfaf58027aa602a3f914823edf82e94ae4e8388cd36e6ffdf7d4b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d19cfbf68dcd86b938fd3f0ac8323d0477034b5b550d15a5e481cd8d9983a2d"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin/"swiftformat", "#{testpath}/potato.swift"
  end
end