class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://lusingander.github.io/serie/"
  url "https://ghfast.top/https://github.com/lusingander/serie/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "2ee06db3694e8ac4c1c0e5e08f3a46de69780637539862b969896d9481032085"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34ca6ee6372bcd9f2b628eeba50ffccfebff24d0f4c01ba55699609d2817f461"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a2a601e62cc74e16ec2a20369805d9d439b71006e62aaa72f89c31472f46c14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bed1b9057bd0fd37e07b7460499cd89bb0530e6d3dc80049493a925bd367dd02"
    sha256 cellar: :any,                 arm64_linux:       "9941b6c3d3d6f85afad4f2e5363b06069065a23ac7b37591fb7f6d511d83a6bf"
    sha256 cellar: :any,                 x86_64_linux:      "59d8dbe92378c70ee45a5bdf36eabf1da971217f930f5aec9c400aa46fdc1af6"
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
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/serie > #{output_log}")
        r.winsize = [80, 130]
      end
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end