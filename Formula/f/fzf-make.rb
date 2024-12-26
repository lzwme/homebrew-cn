class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https:github.comkyu08fzf-make"
  url "https:github.comkyu08fzf-makearchiverefstagsv0.52.0.tar.gz"
  sha256 "4cb9b8c0fbe2727b29269bb3db389b31814de2cbd15ed33de2ea9b5f3a4c7713"
  license "MIT"
  head "https:github.comkyu08fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ed132d902f5de26280192e777d68afee735771e2a6d239d478334c5d054ce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d47d7bba21d510ee5c33ce9bd619bb28f433055f099db77a31590776ba0a576f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f0334bec304ddb810f198534127ab1e2579276259e5e8d922a0184fe855cf1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dfe1dccd504fe8704247f9d7ae459f77958b63d911b168a9e79dc8da8016d8b"
    sha256 cellar: :any_skip_relocation, ventura:       "bcad1e888b7bb7b0d26f4d77178525753f82e865b67527f361459cec9b422542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc0122cebbd3e98fb562a2b51adcbf4e756dc976a97c475969e500fee4bea7f"
  end

  depends_on "rust" => :build

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