class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, yarn, just & task"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://ghfast.top/https://github.com/kyu08/fzf-make/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "f216f88bb45a3ceb25379a31279acd2da22661a5b66baaa0a7ba965d3b74a31b"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ef9e6a44ba6cd611efa59440b23309f3e4df0d86434d444127f23d4cda3415a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b196e5969cbafce4b3d871b32f842b52155215d0e21dafdeae264e9b1c89e528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f9bfdd9a6d4354e181fe8e155e9b152358af49a878db3d07197fc6d87085e86"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f373eb865e210741a298c3cde9b7bbb361f7fa608cd900fd3ebb71b6b7be301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd9b0f16ff01a7db0278ae243e619b36c0601b6907f77d68de0b97af63429b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81e1ffd5997c4fa0cbad7390d5dbffe39527ef4a68c018ffaa350ad85bfa861f"
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