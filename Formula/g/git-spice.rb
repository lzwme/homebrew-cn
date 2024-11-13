class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https:github.comabhinavgit-spice"
  url "https:github.comabhinavgit-spicearchiverefstagsv0.8.1.tar.gz"
  sha256 "4336863f756709bff6a1a39430512734faf823c38b922a60ea43cb1bca1e9908"
  license "GPL-3.0-or-later"
  head "https:github.comabhinavgit-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6a5f405f3321aeec60653f58e389542db6b53a2ccf00981d1e468997322b859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6a5f405f3321aeec60653f58e389542db6b53a2ccf00981d1e468997322b859"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6a5f405f3321aeec60653f58e389542db6b53a2ccf00981d1e468997322b859"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e4c6850a0fce7529376eec85eb11a79480b24e5d4cd008ef763b5d21404b5e7"
    sha256 cellar: :any_skip_relocation, ventura:       "9e4c6850a0fce7529376eec85eb11a79480b24e5d4cd008ef763b5d21404b5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee01da42d93f86411695e7e2533932b60abcdb17ad65d4faae3a64a8d801b47"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"gs")

    generate_completions_from_executable(bin"gs", "shell", "completion", base_name: "gs")
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