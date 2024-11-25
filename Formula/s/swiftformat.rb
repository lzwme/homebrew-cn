class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.55.2.tar.gz"
  sha256 "76315fe2ab2bfcd087f4a355c0f4cf752cb8d21fad520521654ff50269e7d5eb"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1574c8ec95b85dbcc192977e3b961895661249c006ec8256fad2c144b120a54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9a143ddf86e2d36e426ff874e30c497790ca0cfc775cbf858fdf89e2fc7ddeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ddbf04449504f60ee538f078e15e11bc94dafcb892ff790ca313d7630e1601d"
    sha256 cellar: :any_skip_relocation, sonoma:        "670b1bd51cd26556933eec3bad67b02dd928ccc3ab2833eb30226fdc0db2e431"
    sha256 cellar: :any_skip_relocation, ventura:       "4a84ae76fe2611d6f5b3ee8dbba3e826beba9bdb009f85a6e8d4f77f1d2358ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d7e27757d5e139a04270be0c0f5e08838dc665f4dd8cc6a3c06e9acfdd4eb50"
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
    bin.install ".buildreleaseswiftformat"
  end

  test do
    (testpath"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin"swiftformat", "#{testpath}potato.swift"
  end
end