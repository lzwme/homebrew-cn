class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.52.8.tar.gz"
  sha256 "1c5ac6e5c88debb87ae03978860e5ad04e0749af0486f35a542389c301e150d5"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4e465509b595538b109e22b1bc39796828b44aaf748ebff7e8ceaf0628dd626"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab38b359d9b40e9e8496f65a4fd93d2da26ca2bc41cf1268a8bdd01618c61906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1e11937519e30aea5d8dcbe16a043006284811f559036d6eb875df7e529e21"
    sha256 cellar: :any_skip_relocation, sonoma:         "daca6a0807377907259998133d7295aae5bbe9df5d6bb2d5c477a1b1a5f29b7d"
    sha256 cellar: :any_skip_relocation, ventura:        "60a8c165ae748385a08c5bca36a2aa516cc8fca28b293718d081eea66f3b9607"
    sha256 cellar: :any_skip_relocation, monterey:       "46454994e2752ad7bf0673d34548e5dba9ed7e67509cf9115f63b0a4eec835b3"
    sha256                               x86_64_linux:   "bcf2bb8bab838a2038be86687d381bfd21496e99786460e4065cdcdd5a567698"
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