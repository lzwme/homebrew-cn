class Tenere < Formula
  desc "TUI interface for LLMs written in Rust"
  homepage "https:github.compythopstenere"
  url "https:github.compythopstenerearchiverefstagsv0.11.2.tar.gz"
  sha256 "865c9b041faf935545dbb9753b33a8ff09bf4bfd8917d25ca93f5dc0c0cac114"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cfe044f70a14a46fbcc13fd9567b1d376a1081829dc4ab41e7d26772da2c4a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd39545ed71c5c4bc73698cb55f8c686e770100e36c6843f4c73a9659aa6516b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ccc493d54b1090b493158af6816e5e2ea88d5ee7bb96aa07106f45bd2f31c69"
    sha256 cellar: :any_skip_relocation, sonoma:        "853a57352491e3bed077f2a9f49b41750eb55737993a91d181dbb7cbe5d617e2"
    sha256 cellar: :any_skip_relocation, ventura:       "db5cf107adb337ca8ae33f16b77be78413fca5eef6bf9a32fe4bfb74943cea1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eaf02aea5d55524a747a79e3ea5b88a467a491e31acb86a7a9630680cc9b498"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tenere --version")
    assert_match "Can not find the openai api key", shell_output("#{bin}tenere 2>&1", 1)
  end
end