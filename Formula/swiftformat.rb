class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.51.8.tar.gz"
  sha256 "30e7fc66362925142b88d46d5ab196828d9e3bf24ab1fe75d801cbe68f9cc0a2"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b8c98ebc148e96c94ec171f128fa6763141c18941a826a8e207f7f2825cd66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcbf2be466a5890a799eff150f498220c78cadcabed3d7fd69bfe516c1cbf4dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "566511941a0d542289f2a0308df67fd65642f17771aba6fd149da6d9adf665bb"
    sha256 cellar: :any_skip_relocation, ventura:        "25c002f21ee7eafc03d13e8b200221b8f89f7c891c184ef5f3ea484fddf5f214"
    sha256 cellar: :any_skip_relocation, monterey:       "26decbdb34bcaa4e388bae41d8846d8970dd9d98d9f12ce6e7f2ab8e1d0458df"
    sha256 cellar: :any_skip_relocation, big_sur:        "760ad90b1b608ff0356718a72a135cba84c4872b534ff2f60e0d368e07ef9a58"
    sha256                               x86_64_linux:   "ef409ec4018b3374110f8724db5cc3dee5f4c7173b29e90c91047a8930165173"
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