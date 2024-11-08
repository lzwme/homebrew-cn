class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.54.6.tar.gz"
  sha256 "6149936f669e672705fd0be87759548b57ed28da32c13d054a285dd08fc56ce3"
  license "MIT"
  revision 1
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03eb08eb7de0e697e574b5d5c94104a88c9548ee880b942f1916536fe7ff897a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ff9c3c154fea61303bd060da1aecebb025a3a33460b24910cf55e6ae366574e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52200577da57cebd27e7d4b6a9ed84f6d3475b7f91e28ec4f5947fc2992cd943"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f79e28a0a5c7172be8bfcf23fca47de08f8bc03a3ddcdfbf52704445b9d8b18"
    sha256 cellar: :any_skip_relocation, ventura:       "416528899d45dc25edc2f14c857239a2c922b4be548345423857f140c6b90f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c47e1a74da98ff5646c8d510ea5e6de45e9dc97bc59f151bd2a8848b5bc9f8"
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