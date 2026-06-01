class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://ghfast.top/https://github.com/austin-weeks/miasma/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "c257e453154d50e07abf1b98cf8bcbad2ca1e23bf606b1d0d0e3076469f607e6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d30dabd5fb6229a73391033bbb78184feb37904b7436828eac798ccedb21068e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebfb4b3550897391fe89e19bc14e2c76a8a6501e2a45236c2335625115c4ff1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbdc19de887e0144a0b2a59e5d29dbe762659e26eb92b82febf3e43667a2233a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d83876cadd8417ead51830b6dd0c559625c9e2d72717225984e4d4afadf10b70"
    sha256 cellar: :any,                 arm64_linux:   "714a2ed0e337681791d31c84308dfc6c791d9d883b0e178b94e537707ff68867"
    sha256 cellar: :any,                 x86_64_linux:  "f23e6e4e9ed03eaa9334a0f4422217dde36235307c52a5faa7dd227a25dec9fe"
  end

  depends_on "rust" => :build

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = spawn bin/"miasma", "--host", "127.0.0.1", "--port", port.to_s

    # give the server a second to start up
    sleep 3
    system "curl", "-sSf", "http://127.0.0.1:#{port}/"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end