class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.55.1.tar.gz"
  sha256 "c8c3b18dbd20b3f9a7eb9683b05974f629738d02d70980b3d265644662f6cb49"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22c5c775d1c65e04d368f1c15ec0ab0a2fc98c8bc2261f32955e4f975ca01962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "663b2eeaa6234dcf77a066560a08ae402aceb1571c89c9dce7bff17a72f030ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18d034b13ac095db9ed7e7096a65d6cd5ae1b08152e1a87ee87e065f234a62d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6e7f7daae94200a3d488ee18af0c2f680fcf1d101b55a42a0c378d2dc6ec731"
    sha256 cellar: :any_skip_relocation, ventura:       "490837024e5d3711d82eab82521bc0e0573b94c875163b999051ba1615c17f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39725b5eae5154f93346194eff28f60be916af7e0c86212acd3fdcc2fd4a9bf"
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