class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https:abhinav.github.iogit-spice"
  url "https:github.comabhinavgit-spicearchiverefstagsv0.11.0.tar.gz"
  sha256 "8a7599645a7181ea2d292113a370751057bbde582c9abfe9bcb3e3f73bb1cae2"
  license "GPL-3.0-or-later"
  head "https:github.comabhinavgit-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1385ef5895f71f76dade21744debe6e730de7b13ec27818718eb756d45c2307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1385ef5895f71f76dade21744debe6e730de7b13ec27818718eb756d45c2307"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1385ef5895f71f76dade21744debe6e730de7b13ec27818718eb756d45c2307"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b3d038ec01e3e2f032b1f0b57885fa964b3e1996702311c578a7b9fd6ba7557"
    sha256 cellar: :any_skip_relocation, ventura:       "3b3d038ec01e3e2f032b1f0b57885fa964b3e1996702311c578a7b9fd6ba7557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb6ea144a7a47972bbd1a9a93a5c8436e684debfcb6486d037af2ee3e6607d4"
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