class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https:github.comkyu08fzf-make"
  url "https:github.comkyu08fzf-makearchiverefstagsv0.49.0.tar.gz"
  sha256 "1bcf494bda624ed08512a35bd2303d3d398fa8f5d7439872eca33dc4ed606ac4"
  license "MIT"
  head "https:github.comkyu08fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f1e28cf796d0c579fb9d8d76527fb93e9f98b35ae99f634b9ac23e155f10873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d9577123a9b2ec30065080c185cf09fb2f6759c707c9a011773913566c44cef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fbfc15d584f42bfaf17845f05ced3d40e007e5568d6ad3c5f58f22b70fd5df3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fad65e9bd86141c2bb7df52f025473ac0d60ca9839911a8bb621e19414372cd"
    sha256 cellar: :any_skip_relocation, ventura:       "58489eb741a2906480575f045af20bf92ab50bb7abb624e28c8778dd3e337b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a95b94a8128aa20a7180a36918fd66a6d312291cb2d5cea813c6897ad97ebb3"
  end

  depends_on "rust" => :build
  depends_on "bat"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fzf-make -v")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath"output.log"
      pid = spawn bin"fzf-make", [:out, :err] => output_log.to_s
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end