class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://ghfast.top/https://github.com/thomasschafer/scooter/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "6d03fcf8809ff61a8483b07300792b5deb0dc22f6295b498e729956c4a4c5823"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "252bf96b4f090e07d065a7049f1c708943364a2da7b6626f96750356b397bcde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2da9a15f25222ee37cd62ea3e66b207030ee2920cc8ca1e479ba436c83cc4c1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "877d364e7f5113123d5bd285444a607bfd4d2014c5cbbb293314049c6340011c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a09a26d2fed3b7d70e8e27e99a49c1b0f5ec67a767c0708bc6f6f8220d88f6f1"
    sha256 cellar: :any_skip_relocation, ventura:       "d5bf8d497c86e1fb090d93cee5aeaa0535d44532348e3519f48087a17575a898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfebfb323c323034656a0fc2f4dc9a03e591cb9d28ce3372bfb0512743ed83f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fe03e99a6602cf44dc90f59fade468a1a4f9781b8c4fdf0b3f3812c10c512fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end