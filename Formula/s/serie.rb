class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://ghfast.top/https://github.com/lusingander/serie/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "f713f7490df39a443381dee71c1f64add544d5014052527ce713c30a62b16515"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba3fc304e393da51df730d190dd24f2820ac66b127dbcccd4a58a7afccdfb31c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1298e813db574e520435fa0be7b453177669b4b95bac760b72ce49e4db4f32d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "408838c9ba06797b3afd75f8ee872bc9a49b02701772b5fbbff6230fc0b62c43"
    sha256 cellar: :any_skip_relocation, sonoma:        "74753a8f6a4b99319c82c0239eebd8c40507010bcc8a92606768805df359162c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c735e7b70688cbc7628916a28ca5cc27becc3db1ad25a7cbc511ed75cfe19c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fa1a7fae4c4f1c3fd5d9a4e911a34a9b76a07d686ed8a79deef3f9d809cb4d0"
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