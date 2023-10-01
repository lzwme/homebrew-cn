class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.52.5.tar.gz"
  sha256 "c4963a341c4a627330a2c2fbea08b8e8b7751d2315ce7cabec3717c4c46183f0"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aec90b56e4afbe94fa1161c7e946a4777fdee5297c7c3bba75f717943f78327"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8d6562a30fd9f7af93dfe40107ec21aed4d67350faca250d3b0847b706c15d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cd900f9cdc4dc35ce52a887fb6201cfc449fd4c3952bfbd1974cab1c5f63706"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c0fdbb520b80be072d9fa2fda84f36dc61388767aa77713b7e00f3e47e3bc04"
    sha256 cellar: :any_skip_relocation, ventura:        "4d5c8c7676882ecbadaa0d064a86725d83542fac892855827c287207ef4475c3"
    sha256 cellar: :any_skip_relocation, monterey:       "d790e75d0c001e1fae097e78f0611184a4746eefc3c22f888e0ed1167c56236e"
    sha256                               x86_64_linux:   "e8c21cb4c6e3d0d4ad85121687199c265125dbf81795ed3f1d04e8bdd055f47b"
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