class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.69.tar.gz"
  sha256 "8f66c0199056dc9d72e98b2fa610cc43693d4d3104981e77a9294fb7a22a4329"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f69ff81ea701f901c7b6cd01f339523ab44369c7774788e37a635ca0c1a4c613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e84bcaed5af97c9e8cff524b6d463c84f4ea354c104ed48d96456d6850505af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89fe2ea2e6b19219b1db0337f1cc2623caa1c99fdcc415c3efbaa0bc6feed254"
    sha256 cellar: :any_skip_relocation, sonoma:        "c022a0961c2e07c0de4e76cca81c9d664c32a956f125f5150e80a578e8adce61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcf7db82b4bdd9685426550066eccd066196b17aeb6619db067c84eb64a1cb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad2c9dae730310662aa0318f59ea3317e1acec7d3c5d7e63f40d8b42865c49f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    # Test script mode: type text, save, and quit
    commands = <<~JSON
      {"type":"type_text","text":"Hello from Homebrew"}
      {"type":"key","code":"s","modifiers":["ctrl"]}
      {"type":"quit"}
    JSON

    pipe_output("#{bin}/fresh --no-session test.txt --log-file fresh.log", commands)
    log_output = (testpath/"fresh.log").read.gsub(/\e\[\d+(;\d+)?m/, "")
    assert_match "INFO fresh: Editor starting", log_output
  end
end