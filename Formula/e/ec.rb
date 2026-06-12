class Ec < Formula
  desc "TUI 3-way git mergetool"
  homepage "https://github.com/chojs23/ec"
  url "https://ghfast.top/https://github.com/chojs23/ec/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "9598d57cd71c35c057ce92fda690380e3a138b44404ef14cbedf9f577772b71b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "777f6432331e4561b744a676cb8f5ab955016bd2f88d4f6204f794c1cbca341a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "777f6432331e4561b744a676cb8f5ab955016bd2f88d4f6204f794c1cbca341a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "777f6432331e4561b744a676cb8f5ab955016bd2f88d4f6204f794c1cbca341a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c911ab3e324756b8d124d455e29eb019a27529a9fcc4c8a06982dcdb0d47c7c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47eddd74f5e819469ab11c03ae6bd5cfe7bfe677092f4d651ed4b3c98500cad0"
    sha256 cellar: :any,                 x86_64_linux:  "4f4b80eb16a6dbbb9417a10b72c1fcd32cae387757bf6a4508457087c9a1b513"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ec"
  end

  test do
    system "git", "config", "--global", "init.defaultBranch", "main"
    system "git", "init"
    system "git", "config", "merge.tool", "ec"
    # force "theirs" merge strategy for non-interactive testing
    system "git", "config", "mergetool.ec.cmd",
           "#{bin}/ec --apply-all theirs \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\""
    system "git", "config", "mergetool.ec.trustExitCode", "true"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"
    (testpath/"test.txt").write "Foo\n"
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "foo"
    system "git", "checkout", "-b", "bar"
    (testpath/"test.txt").append_lines "Bar"
    system "git", "commit", "-m", "bar", "test.txt"
    system "git", "checkout", "main"
    (testpath/"test.txt").append_lines "Baz"
    system "git", "commit", "-m", "baz", "test.txt"
    assert_match "Merge conflict in test.txt", shell_output("git merge bar 2>&1", 1)

    # make sure ec detects conflict
    assert_empty shell_output("#{bin}/ec --check --merged test.txt", 1)

    system "git", "mergetool"
    assert_match "Foo@Bar", (testpath/"test.txt").read.gsub(/\R/, "@")
  end
end