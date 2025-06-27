class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https:abhinav.github.iogit-spice"
  url "https:github.comabhinavgit-spicearchiverefstagsv0.15.1.tar.gz"
  sha256 "f10bbe6d27c68957d52859c81a0f91f11389d77c3f8ee32791040d80d5124e60"
  license "GPL-3.0-or-later"
  head "https:github.comabhinavgit-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5996c91ef5186590d7afe73429b2568f8cdedfbd29f6a2f9e7b685f2d55adf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5996c91ef5186590d7afe73429b2568f8cdedfbd29f6a2f9e7b685f2d55adf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5996c91ef5186590d7afe73429b2568f8cdedfbd29f6a2f9e7b685f2d55adf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b757f83fb8a583ff389d8e3f4481ac40febb11690b977a97b6dfe6eee511060"
    sha256 cellar: :any_skip_relocation, ventura:       "2b757f83fb8a583ff389d8e3f4481ac40febb11690b977a97b6dfe6eee511060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a1d2413cc3e6e79a4932ed5ff8d21df76d4b00477854669b488112f4f31dec"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"gs")

    generate_completions_from_executable(bin"gs", "shell", "completion")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}gs log long 2>&1")

    output = shell_output("#{bin}gs branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}gs --version")
  end
end