class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.56.1.tar.gz"
  sha256 "58ddb99c2c70268872aed1da1d7018de51cbba9e5be7a2f9b7285d43ec3d4092"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9cea5a4fce1b1590ca3f892a14cee5ca8ae34ede64a5862758b35da4f784bc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9863dd7cce8f792175a54bc3003c70cb50f26bb2ba0c7b905f5ad87d60f4ef77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a8359097090bb54457e59a05aba5e37a13398261dec600f380ff908262972f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c73ecf2870d636fc83a7671448f6b9e2b5a3716c83b5fa95d6d4bfab8fafc4"
    sha256 cellar: :any_skip_relocation, ventura:       "cf9a53b0afa4ea86287d303fb24e257e6b969d20a96c09f6fc17f7d18bb816bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75e8193c06f09fed008c40e26ef3cb31f0b010b41bbea023569dbb1f553158da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "216aa98711011b57b2261ad311a1737f78757df8d8b79bd3e3759aaa47875df5"
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