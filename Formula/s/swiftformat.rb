class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.56.0.tar.gz"
  sha256 "88e08fb85fd72f50061c7a6278517b43029a98bdf39d2d4c635a01ee9b435276"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c8299cb42c7453cd9d5dee8e82a20d02b36bc076c57ec8c168d1ca497849de7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aab3754ce7a40acd485ba02a7bb9633e4e80fc0ec621dc2c78cfc2f2087f688"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34cc58ee6dd254e5b6239cb9c09215c964bb53bb54f6ac419c40e9a8bfe2fadb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a2592548bed75356c26032cc3d71f63c6ae5c5cfb4bd0c410118a0c270c59fd"
    sha256 cellar: :any_skip_relocation, ventura:       "dd9b92c9eff14264681b7e20a3855fe9f93af2bcda02f1555c9315bf095dfcb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6933b0f1bda88ef4bc694f1ddb399772ce127023fd78df3ed9af7fd3bb201c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cacb8521b982b5fec4117f19264fbdffc9abf7077479179f7315a40deadda3d"
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