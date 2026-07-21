class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://ghfast.top/https://github.com/abhinav/git-spice/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "0eb773fa97084137321ab7af0d27462550efc626cda6adfdd191800d33bd87e3"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2645ff0efeb7e1987552ce2f297d8dd66e2856fa03771bcd8def8ef849c473fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2645ff0efeb7e1987552ce2f297d8dd66e2856fa03771bcd8def8ef849c473fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2645ff0efeb7e1987552ce2f297d8dd66e2856fa03771bcd8def8ef849c473fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f1cba92137b2f94df0ce062395668aed05c87a6323abbbde7771937bbf20983"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96c0d5ba13b4b25570f36acba47cf5238031ca4026be3b61fba64fe658f7b811"
    sha256 cellar: :any,                 x86_64_linux:  "3c6821130dd6cc0f1c7662c4babb4f5e56a879742c3706fc9fab111bf7776fa7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-spice")

    generate_completions_from_executable(bin/"git-spice", "shell", "completion")
  end

  def caveats
    <<~EOS
      The 'gs' executable has been renamed to 'git-spice'.
      If you prefer to use 'gs', add an alias to your shell configuration:

        alias gs='git-spice'
    EOS
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/git-spice log long 2>&1")

    output = shell_output("#{bin}/git-spice branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/git-spice --version")
  end
end