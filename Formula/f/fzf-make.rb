class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https:github.comkyu08fzf-make"
  url "https:github.comkyu08fzf-makearchiverefstagsv0.43.0.tar.gz"
  sha256 "7679571c7c60b9063233d37301a2528d2edff696eb0ff900c858eaf0280461ed"
  license "MIT"
  head "https:github.comkyu08fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "035c6b9dc54a24ce1a635dfa56274a8316600411926a53c62dee066bd20551e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d478fea91c206280ffecd63d0857e7cbc46faec56248809c9f80ccc1e3e0ecf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cadec5a3c5178b64e43cd25c0cfcae72b87cf923ba55980ae5431f0bce54ef52"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b93ece19038d3b9c4a77619ef4cdfe3dc3c460549fb79ae6de17d2a81627f8b"
    sha256 cellar: :any_skip_relocation, ventura:       "865c6ebd9d084c086981bb69e2d576d13f1c792b6db298638d1596a14a6f20ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "605fcb55fc94d155d9b9e8a5168c9815fee99cf6d2fa63ab433ca85ffd233b1a"
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
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end