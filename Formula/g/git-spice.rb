class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://ghfast.top/https://github.com/abhinav/git-spice/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "de79e41e50a341b0445cf81933919fd2f7cbc6b1feb82bd56585f51e3afdc94c"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5df7b42e50b8852e2ba44ff2f12486b980620eb6927e08bdf5110a1eae543442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df7b42e50b8852e2ba44ff2f12486b980620eb6927e08bdf5110a1eae543442"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df7b42e50b8852e2ba44ff2f12486b980620eb6927e08bdf5110a1eae543442"
    sha256 cellar: :any_skip_relocation, sonoma:        "25150c4488f6d04d23670520ce110bd2b9ef1f9627ff67129432932fc5568767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2d8ff19b67a97292350c17021d19e42762343f62a8b53e03912997cd933c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50a8c986ed3d9540f7f2e98684befea91ad2505cb11a1a60d7fac49c04b8f2f6"
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