class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://lusingander.github.io/serie/"
  url "https://ghfast.top/https://github.com/lusingander/serie/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "560e27fabdd6f45f44fe5f1200c009c0164fcf41eb7e11370788e939c265bb82"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "706f39b21421a7d7cee5d34d1607ce7991074101270e1caf86225f3a491a6924"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c52454dc782733ef4fc03a997e3555ac91fcf60b94b9a6bb68c93a1b1e2d6913"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "46ad33d2e7cec4a99881febc311ec39d9f2dbf5b826d58b9ace4c089fc4a78a4"
    sha256 cellar: :any,                 arm64_linux:       "1f514665eeba99e0a4984bce34bb5d6578eccb448b9a3f6cc6e2d4b6ffcecd46"
    sha256 cellar: :any,                 x86_64_linux:      "87614acabacd7c5fff3cad2189d565fe3ed17e3cc472e4a1df4c90b48e5267bd"
  end

  depends_on "rust" => :build

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