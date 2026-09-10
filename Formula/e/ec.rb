class Ec < Formula
  desc "TUI 3-way git mergetool"
  homepage "https://github.com/chojs23/ec"
  url "https://ghfast.top/https://github.com/chojs23/ec/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "70eaf75969cde5b823d8dc4a4d2e575ceab903edab8277212afc642b757e5a10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82c6e8c16a731484b911afeb24bd382fa99a884404cf95a17d01da47252e74be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82c6e8c16a731484b911afeb24bd382fa99a884404cf95a17d01da47252e74be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82c6e8c16a731484b911afeb24bd382fa99a884404cf95a17d01da47252e74be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c776859e6c3f7e4b0dedecf73e9fa05d5cec3e5e401fbcc143b75fe74b8efe7"
    sha256 cellar: :any,                 x86_64_linux:  "cc89eba1f5b6c7b20ce21e01d30baa9a79013c9977000d31d1b03f53d5b04806"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/ec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ec --version")

    system "git", "init", "--initial-branch=main"
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