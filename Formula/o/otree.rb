class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://ghfast.top/https://github.com/fioncat/otree/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6d66cdcce5a08dfd9c9ba276a8bd6fe7ea65f1e35d4a955c41402bcb3b86e05b"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e63fc1c6c13d0d5caada9d836c7c4b9648d538b3f9c5c71dc197167206ad4ab5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "371d727d73e9bb63fb571f14a5760cb6d313ce616c4c7e03937c9039f54289e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d460e1c4f6b9cacd6ff42eef418cdb879f4232d17d713878845a4133748adf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8b5313ea2c6270e42b40750cc217ba050b5191c8932e297dea906485548b120"
    sha256 cellar: :any_skip_relocation, ventura:       "557d452b3c9b853830b6df876047481e86e8262172f0f34700090c3688ab2acd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94ee7b565ba0dda7ec69475fd55b25171b6d22e3a42c3a972493b91280866e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d7de2d99349ec7e900c3f26ba7a5fcd882e5a1ddd7b191d7fe0b5cdfed2d1c2"
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