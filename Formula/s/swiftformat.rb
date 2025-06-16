class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.56.4.tar.gz"
  sha256 "4daab67739631bb69bca5fc513769e629d37239ec8a199a659d4d48807286592"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2af61335aa61d6650d43c7fc8c44c6bd379a78dd23442950d0d6bd6c3339680d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8998287c9941652bccf88d34800403a6a82fe0d2bfad4c821906f4dafc97d71d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30d6c1e51d6e69b4aa380b8404499326155fa6a580fa93e06e7e9c3e5819fcda"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2997f32d76167ba0bb0efd0770f2422e9dee6a1750de67895befe47ea4fb540"
    sha256 cellar: :any_skip_relocation, ventura:       "88410246f58f51c5b12e3131b194eaf8cf5f50e63bb732deb09801b4c5028506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aedb74df45987bbcfbb1d7ea51e2e5803867f422956803b3be4f9e042067f2e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b645b9faab6b968d87af27f9b8cf31e5e83d7d316aef4b238e41ed298b82cc"
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