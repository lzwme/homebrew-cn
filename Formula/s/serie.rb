class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://ghfast.top/https://github.com/lusingander/serie/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "d24a8b0eb3bb69ced3d7a2d8fd2ce37db1688d6d5e24f4932abed906bef85b21"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e69f9758e5b89c7723196cee4bf8c7fa38c8fb82d49b922bc3c90a82a77fc946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c52e42fc7737639103cdf11776d24679f53f2228630e545780267505bbb956e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66ddaf6b4e7e4e3ef953e65c1b58e83af30d0c024e48d399644d685e884ba167"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5ceec8d4590f9351ee961262cb8a633f3be2f4a8ceefa3f0959f1fbdfd901d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "835a842ea7d0cdb9261048d028f59b7d35f32ef3cd86acbd47e76489687adf87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6ea1dcdb983e24b8ee691c0a7dfe8718f02b260b6b77e584a3a7481d7e8c8d8"
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
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end