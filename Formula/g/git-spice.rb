class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https:github.comabhinavgit-spice"
  url "https:github.comabhinavgit-spicearchiverefstagsv0.8.0.tar.gz"
  sha256 "314c97aa32679eaf3b1a59442021279b837eb6e06156268fd5395c347bb61ed2"
  license "GPL-3.0-or-later"
  head "https:github.comabhinavgit-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "772825804e2618b443c8eaafa37e636a445c4c8b3d995a21b4f428d32e579060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "772825804e2618b443c8eaafa37e636a445c4c8b3d995a21b4f428d32e579060"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "772825804e2618b443c8eaafa37e636a445c4c8b3d995a21b4f428d32e579060"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e3aa6c9886443e6fcd50b408517e8e83866651ac7908dc38cdb9be28670a589"
    sha256 cellar: :any_skip_relocation, ventura:       "7e3aa6c9886443e6fcd50b408517e8e83866651ac7908dc38cdb9be28670a589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fda1326cd8ae4a2ac2d1c8ecaebc8b1a8dfbcda95ab607ab746b9a224ad9f1d9"
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