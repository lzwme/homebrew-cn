class Pdfrip < Formula
  desc "Multi-threaded PDF password cracking utility"
  homepage "https:github.commufeedvhpdfrip"
  url "https:github.commufeedvhpdfriparchiverefstagsv2.0.0.tar.gz"
  sha256 "b00c01f23f02a067d3fec48ee42d0ed42796fc6f3383537147c7f9dd74257b40"
  license "MIT"
  head "https:github.commufeedvhpdfrip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15f5ee4fb57ccf399df62da8cd7561fb2855166748bcf80832b79fcf3c77a841"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f09675f6038d497b4e8057a38ef51568dded07498f511dfa0f535a03a075c90f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24b1300860e448174597b7124fef3e34fcabd0eed157cfc8205f8a7744c4d97f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c0f55e2b7d85b5bf53718b34633755230c8934812070d920b7bf7212dbe5e59"
    sha256 cellar: :any_skip_relocation, ventura:        "8567db61e3ac6b3255196a08ff55eb73bc11153bb9d092916661f944823b5df8"
    sha256 cellar: :any_skip_relocation, monterey:       "a57580e41624f889ebe46769a4a36baaa7e1a125f69f773ab9be90443582d240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f5a311aac1e21dc73a89c5cb3d8ed07b54de72f5337b30f92b5efb33ed9ca29"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pdfrip --version")

    touch testpath"test.pdf"
    output = shell_output("#{bin}pdfrip -f test.pdf range 1 5 2>&1")
    assert_match "Failed to crack file", output
  end
end