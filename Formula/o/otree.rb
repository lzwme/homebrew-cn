class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://ghfast.top/https://github.com/fioncat/otree/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d5126b1231b00fe6c8bfb0ecb94e86d328090c1e33261922f54e79ef647aed42"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "070383b2ad8b2b17ccd07adda9dd8a9ffd42cf6119b1121cf1b101f5cfd9ea65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e98f56da2d412f904d0f2347b564cf20549d66774c13323436ab17f717586dee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28645d521c25e5e5af441c9687a5fd679604f5022ff5ee5dab5c3b3634920dcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3517c4662dac362d9d4ac5cb9664d63734ce34abf5e3737cea40d13b04bae240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "355722ce7ba99f421e9d93548f17cd069783a65da83459af03e8618f02183459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c39bfd0c7e3620313ab2dbc454545c11348230876390d443fb4e22d0be25a167"
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