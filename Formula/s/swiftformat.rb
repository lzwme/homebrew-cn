class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.52.10.tar.gz"
  sha256 "5e6df043dbe44b99ccf4929b675224983e24f5f2900f4aa5e1d87796e6adf6db"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9df532af6d6497e9c479a0a7f1788c01c11e4b4c71b16a6c634781c0356a3add"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61b670a5eebab1c623373dae81c0ccbed5f47c8d0cbd4734b8034550351b0c05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b459f3574c916c609593b01b7da00c8dbb657269550da864551fc700e7efbf8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "135379344c2e9054cac45d22cdc36252d016d118c98e7a909b7bd397c634b5b2"
    sha256 cellar: :any_skip_relocation, ventura:        "f04a9e9cda5e74146af7022d054b162eb6498c75c0a0ff0c209d74b23caab542"
    sha256 cellar: :any_skip_relocation, monterey:       "380ea23299f6cd1a79e74e53c0dcda5791892a8209bd52af2c798f6d1b783b58"
    sha256                               x86_64_linux:   "f61003b66bc8401b3140254a914ba7a36e6c285f0ba3ec1d287f49e33a86911c"
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