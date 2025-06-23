class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https:abhinav.github.iogit-spice"
  url "https:github.comabhinavgit-spicearchiverefstagsv0.15.0.tar.gz"
  sha256 "445f41bef80212bb198b3d8a6cb4d9138b9c3dfbfb69ab557c2a29e062e1af3d"
  license "GPL-3.0-or-later"
  head "https:github.comabhinavgit-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7de5693f01d894d612683bdd5a30c4d309412c67071dd3c5418ab352070bc5a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7de5693f01d894d612683bdd5a30c4d309412c67071dd3c5418ab352070bc5a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7de5693f01d894d612683bdd5a30c4d309412c67071dd3c5418ab352070bc5a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bafa57690a31c462b03b05a3c13c0defc2a0b91451c7ccf1f73ea135f98c997"
    sha256 cellar: :any_skip_relocation, ventura:       "2bafa57690a31c462b03b05a3c13c0defc2a0b91451c7ccf1f73ea135f98c997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1bd104ff9c34a53cd8fa25af451570fa2893fa94532bec96cb9e164402a3ca5"
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