class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.55.4.tar.gz"
  sha256 "b72e0f0548ca6e8029a81b4f27cb11b648e84c36f8938b88d75f10a894ae31cd"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3630103f688c867f0400ae75832f9a2704e46c8edd2cb3c867e43336c5067e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491111aa6521d28ff46539dfb95aa22e1350c657c8aab002d19eb7d74925cac6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1fec1fa8008ac7461b23acc0817f1633b7cd636fcd015a7d3c45595dac00d24"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a3492fec361535ee067dd5b3eae6d5ce77d9128dd16f8b447ede4bb73b677ce"
    sha256 cellar: :any_skip_relocation, ventura:       "42f13de50ad12ebc6272f151d17310cea05d1fcbbe9570b81ad6203adf474329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04815282a5c6028bb96b3fe3ed5f5f5bb65ea836b9b4289da276cbe9e95e00ac"
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