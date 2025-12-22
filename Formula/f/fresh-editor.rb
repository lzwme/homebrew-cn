class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.58.tar.gz"
  sha256 "214b110609802963a6e6e2f200bb7893f1eb325f8b39d3cfeb13127f0d5bda6a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a439075565f5a7f00cdaf204119842719d5abfe2b86a858828a73e687e50d359"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b76d1f531c1020e2047ce31ae324720d5280185a1252ed9afc7ddc48e14af0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3260f7b4412568af4d647974755fe88962c4dc21053530d03d46d54cd36fb30"
    sha256 cellar: :any_skip_relocation, sonoma:        "8351419873495bd249ccf5ad284e9793f326727545102c7fcea795d23ce32c6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d36def70aceed3181acf521756ba5d3d8014d0a4499099df55a4249f938e2ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb479b8d881f3c1af8a7d936a66d10929331ef5cfecd067ebc5d35fcde55bf69"
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