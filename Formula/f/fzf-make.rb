class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https:github.comkyu08fzf-make"
  url "https:github.comkyu08fzf-makearchiverefstagsv0.51.0.tar.gz"
  sha256 "27ef18d451eef21b8ac5962f049859e1561689490052dc09778984ed2cdc330f"
  license "MIT"
  head "https:github.comkyu08fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd9bb992546b36bf017bb902065c26d0a8e823fe97b9da59b2293940b77341b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88993e617634f6ef3051eab22997a4de4f486c4c1725ec089e018404aee5c28a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47b6403b662d781acfcdd8b0508c5841342e2b1ea8d6ecd1eb865b0ea9e9ec20"
    sha256 cellar: :any_skip_relocation, sonoma:        "f984417ae6462b936961ca24dbdcc336c895c9b8a205e5c9a582e0a8ba45c2f8"
    sha256 cellar: :any_skip_relocation, ventura:       "493ec6c191ca54fc425fa7bd156a09ee24cadbff2a59d62031110f455f4069e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a36505896e37bc006b70d071fd4b4c1b864a097706539cf12f2783c6bd28d33e"
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