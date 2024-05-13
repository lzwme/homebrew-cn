class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.53.9.tar.gz"
  sha256 "643e6c4be5e6003a9e1a5d8655523bf264c40fcc5e4bdff8860807df6b7cf3c1"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0b8109570d2f90b248db6d1d7eb91f6e6ec131f18a60224c46fc864e1caf889"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b15770d4d5f1162e418e5d4ae585fe2f75f4c63f82a8e4d7d2a25c0312f0ae5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47b3d17fd21dd71abdb9534be2d4b5d9de2197c4fcdbc430f6f2fbb2d19abfee"
    sha256 cellar: :any_skip_relocation, sonoma:         "6649089c7872882d7bc260faf0d46669f60c4c62cf56356a41c410bb52c6d45f"
    sha256 cellar: :any_skip_relocation, ventura:        "7bc9471c689b86871fd0d698e58a53386b1a68ac5935cb4ee0b8024a56186c04"
    sha256 cellar: :any_skip_relocation, monterey:       "dfebe58e813cf4d78cf9b78cb94da348f46a6f4b47e5e2ae8b9b2dd97cb8406c"
    sha256                               x86_64_linux:   "5923fd119e1aa2d52d71af075c387bcfa9b8467b302bd8e1689fbace5219962f"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleaseswiftformat"
  end

  test do
    (testpath"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}swiftformat", "#{testpath}potato.swift"
  end
end