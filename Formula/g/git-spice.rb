class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://ghfast.top/https://github.com/abhinav/git-spice/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "4ad641719252146356731ba887773764032c9bf16d5bad8d2afd83d8d8ad20a6"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a662c49858efad9621c0dd060a063120e987dea41d32606c1399878847ec26f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a662c49858efad9621c0dd060a063120e987dea41d32606c1399878847ec26f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a662c49858efad9621c0dd060a063120e987dea41d32606c1399878847ec26f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc83ca51fd4f53c54a5b02b00959871b30143d1df93fe038bb3aafa2996dafd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef592152cca9a6127fd0a385e619628c78115f521ddaeb60633e2a2e410bf411"
    sha256 cellar: :any,                 x86_64_linux:  "11a802218ff1a8c974b339fb3404469eeaa5aeaf40e1d7bf94c32afb710d2b08"
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