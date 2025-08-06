class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://ghfast.top/https://github.com/fioncat/otree/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "73bd4aedc7d36621b62baf46e9f2b57f075e183be5baa1bb388ac82f213e452d"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afe12762ec34d80478c46c1a38aab68357d125f1d6aa478e7b0ce3172e4aed14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b0850d998918ac2a0d76d1ccf70580c73bdd9b582e372be98bbf01ed7cd7d93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "777fde702a1e05e43642150f4f5cd769d62ce7eea49d6d9d387243fb2815bdf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ec4fc67b488f73f4f56f9af05aec2cf1bb703cdc7eac9fd798d9976911efae6"
    sha256 cellar: :any_skip_relocation, ventura:       "20299b04be50ad97a6a1a6450d8f59e0dd1478ad801f13f39797c99ba1b61df4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b7d69bfa5af65b2d39583a143ce31de3a602aa014d599cea5330a2612860b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "515e6f8d79c4409bc083441c24e65604f30b77f61572f99334df9dafcc35a040"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "string": "Hello, World!",
        "number": 12345,
        "float": 123.45
      }
    JSON
    require "pty"
    r, w, pid = PTY.spawn("#{bin}/otree example.json")
    r.winsize = [36, 120]
    sleep 1
    w.write "q"
    begin
      output = r.read
      assert_match "Hello, World!", output
      assert_match "12345", output
      assert_match "123.45", output
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end