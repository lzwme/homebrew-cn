class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, yarn, just & task"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://ghfast.top/https://github.com/kyu08/fzf-make/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "5cf1e13cf9e4a98a4858281970ca2a4459fdc43ef2c200d49228fd8a9cea0383"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8786caf5daf90384cca41a85e1a272a2ad14cbf2bb8c65588a37cebabfe5e9e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e00f0bf4be1b34568d1c6bceacfcc44c6ad35621c25324389a67c31a960a0ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5891f7052de2b659ca652d29ca5cd577f8d53efc36a0280fb6a1ab6c4ae1c799"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b00d80887e02b8e58e4b5dc65fb438de1678545cd241d8e47c0822335d2c6e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "e69cb3566010a4dcd4c37cc887d8ef9d5e0474ac31bef857c3772e6f72405a1b"
    sha256 cellar: :any_skip_relocation, ventura:       "98c74fd06552d5719fad34ebc75b749feb4ecfeb182ef62a4c3f3f989a952900"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da5636126bcea5e3d7f818cc07f8863a72b32934531d6bbb3a10a446ee488561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22f62740efed7e9bb779cc2651c8eb6f6d20c1039ab4413d32759c7d6b033740"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf-make -v")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"fzf-make", [:out, :err] => output_log.to_s
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end