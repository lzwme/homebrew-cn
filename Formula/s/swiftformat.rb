class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.56.3.tar.gz"
  sha256 "61574580b4f26dff64095a5bf415ca171299c3c0a3e6dc536d19910800e2c3c2"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2badab533cc65b793c00ae6e007f5563b7ea97c4fddfb2e64801e5b8011c74d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c1eaafc8665d679caeaf58d1fe8477eb9848dd98f4a62ea48e530a783cabd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e1adf645cf2dbabadbe3b7f1fe65ba6c05af888b00e7dd962cbb66610199ef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a53a01fc8a9d6ecdfd7d43a7dd2288f778b52df21b4aa0bb50e7bce34488e44d"
    sha256 cellar: :any_skip_relocation, ventura:       "4ad42ddf1d84771aed936425f3ff4aec49e195857cb05315e87a1b0f53ff1269"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08fddf82fdd0b191e440390c6ba8bb984bac86646505d391d6236ffa9ca93646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6457ea86657e8146f5fae4dc852d36ab18e52c481cc50c89642f3200a2479a0c"
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