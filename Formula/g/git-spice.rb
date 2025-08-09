class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://ghfast.top/https://github.com/abhinav/git-spice/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "c38ea07d5e6db22880917ff0ac6f5d909844058b01949fee480fed6a8269bd59"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ff4e834450d2eb4a4dd31b5e9944a8945c70b40f1f60fdf8f9b4eeaf2d04a2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ff4e834450d2eb4a4dd31b5e9944a8945c70b40f1f60fdf8f9b4eeaf2d04a2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ff4e834450d2eb4a4dd31b5e9944a8945c70b40f1f60fdf8f9b4eeaf2d04a2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "80c1130063ffd2d7e4f5d50230de219b586fe51e011b3ca775038560d2fefcbb"
    sha256 cellar: :any_skip_relocation, ventura:       "80c1130063ffd2d7e4f5d50230de219b586fe51e011b3ca775038560d2fefcbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5e184e1689e921b9140a2dbf1bc7002a72822a423b4860ee7cbe706207eb505"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gs")

    generate_completions_from_executable(bin/"gs", "shell", "completion")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/gs log long 2>&1")

    output = shell_output("#{bin}/gs branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/gs --version")
  end
end