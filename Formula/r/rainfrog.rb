class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "cbe7f382d43f522a011b15459b4583d46c004f0a483b53d55030a579c47b77f7"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c740751d92b87b711f056b8cacdcda562d75786a450d057de9bb065f7d6bb860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a86c646bf9529f71406cca1d7e19de344551d62a1cae376098f9a0efc8d24d8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4756ebfb1e620121cd955fa0e92c9a727febd865a15dc69d5002ca77ae2ad57"
    sha256 cellar: :any_skip_relocation, sonoma:        "002e7be0d4ad3a17f7611399675d127aeb4fbc083c98ca87ed50b62b4d179520"
    sha256 cellar: :any_skip_relocation, ventura:       "afd14c907c99b2d335a3ae231f2aaa11e9fc567fee3035e39e56ab4a663280ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d044ce22ad5db9463b5b704435b46c89f9d9e1e1e7f0f5740748c263690d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ba117e518a341ef4e4288a5554ebca9490d69ee5ce34a3b77715aceacbc434b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end