class MdTui < Formula
  desc "Markdown renderer in the terminal written in rust"
  homepage "https://github.com/henriklovhaug/md-tui"
  url "https://ghfast.top/https://github.com/henriklovhaug/md-tui/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "8fbc544a08de290d2ff96265f79aeb035ac234c6937fe4fce910333ba275eae3"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58f100463c4efa9df950e2e8361a48afdb4897248421efb9da8e4b730a8a5bce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf28a25802b60e2cc7e47d7f0d4a04febbc6178f562128cb5369fbc39b458340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37a2f1cc0b054a4fead28e6b4b796af209aa558034f76bdb2b37b1710caf3c27"
    sha256 cellar: :any,                 arm64_linux:       "72c7f796f6a8dc14e629397e386332bd0e34a48bf36f2178d0434728169be5e9"
    sha256 cellar: :any,                 x86_64_linux:      "ace0cd8f7f8cbd3d4b529eb2a1895cad00478e816fe95e61c2a230320a0f7bf5"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"test.md").write "# Hello World"
    PTY.spawn(bin/"mdt", testpath/"test.md") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match "Hello World", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end