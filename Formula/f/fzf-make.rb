class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https:github.comkyu08fzf-make"
  url "https:github.comkyu08fzf-makearchiverefstagsv0.50.0.tar.gz"
  sha256 "8f8f516025ff0ef61edb48b1a4f4c578e7560eaa3320aa398f9802e6f6fb6800"
  license "MIT"
  head "https:github.comkyu08fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b6236a5447249cd8d8454b62c31ac7c679992b0d3e6688e6034f6d62f22de0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb7e3e083719a0f90b341c17461d919ecfdb373901f26e9bc92070196bb6eb2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81f8d729d27e69dc69dbe5c4450ad328aa53755898c95c4b2a34dbe3c8ef7c15"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d7e5db623836b9e91a543857659cdeb83ce3cd2ffc3b64bbadac316bdc7d275"
    sha256 cellar: :any_skip_relocation, ventura:       "4d58e288fd3a4d670ac037dea41f275829511806f8a3176f41bdf71d825721e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a512c481f47d753959f477d6083d5c53f6e18bf0e9592a2200a6596fc207c4df"
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