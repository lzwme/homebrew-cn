class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, yarn, just & task"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://ghfast.top/https://github.com/kyu08/fzf-make/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "4990e717a50be9bf4b1d5c46a20c4b7ddf25cd43fc80ddf477c2d5c777e5be15"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8aee432c078c5c9988e6c21126c0d99907dcde33eee75925437a3d35fd031fbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5401d2fa862f05f22b15475b361cf5fc0303a142da7e7635f8e7e2f9862e273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7426ebcafd01e7fb1344f19ed88aab24b6792f87433b0c308f73e1ce08bc5404"
    sha256 cellar: :any_skip_relocation, sonoma:        "99e50581ae76a48609a922868350387a337ad0646484747fdc37c185797343e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ab15db87e3517cf3205b93183e6994452ab9f1f62e65cedaed4f87065168919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "242b975dc0fe87642f8433eb882448c2fec6c2e927dd85b530445faddd3197b0"
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