class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://ghfast.top/https://github.com/fioncat/otree/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "eb3510b3a07dac60368939a3b32364e6dbdc114223cfd1c7e18e90df5c80fabe"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eb7be93852013118df51c302e976ba67cf7b832279d14ee27d0dabb1e28cf71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8a9d125f1312443bc37eb2bd8a9ac32952847b11d544d5ebeb5affaefeb41f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21b98abc843f09547d323c1ff511e80af78da6a661f1485e30bc57aa41d09cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "58ba2098e2e153632085c4889c4fe173212ec39e87e208e8bf176dbeda270cae"
    sha256 cellar: :any_skip_relocation, ventura:       "663d6744a0c2b81187fd02fc5161f1cf9f5722c76f56ef71efda4e8e00100865"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f69ee3dd54f68fd32547ff88e432a852b96f5983ae15e1200d313a98582a24a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94bbf15a6b0e67c05dfd0a82ca019a6a76172ac6bd43f734384e8642d4f1ba85"
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