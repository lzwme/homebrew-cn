class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.55.3.tar.gz"
  sha256 "a961c7512688efde21af91fab35b19d1660065ee9e73846a390355a1b9051109"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dfcd41f999c51f6cba22b48c4329bbaa77217255aa208d9cb83e1fa9afd9f85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40c610daf4c78d8a80a9802d07754a0ed9bae55900d0a0c3d05e2c9cff0c6ec5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d4aab5c44dccb90809daa93e422084dec9a8d1be2fb9736ce7e7b27d074b608"
    sha256 cellar: :any_skip_relocation, sonoma:        "624d74aa0244f740b10c396586f640511980720c19b3941e3898290c2636fbd9"
    sha256 cellar: :any_skip_relocation, ventura:       "d71999ccba326aa80eff5d36753a66a76102588ede17d3c547fd463d91bf401e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b8a48b73ccf33938a8fe34de474fec732cf2c5013e9136b799f3f2169d209fc"
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