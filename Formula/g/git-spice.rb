class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://ghfast.top/https://github.com/abhinav/git-spice/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "3ad2f1ba5423fde1f6a1a5f7e528ad56b1f2aa39ce592c32a75cadfebafe6987"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3f83281444405f4b4c9b8906510e82420818f1abf5a8e4363b7ed0e08f0aabe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3f83281444405f4b4c9b8906510e82420818f1abf5a8e4363b7ed0e08f0aabe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3f83281444405f4b4c9b8906510e82420818f1abf5a8e4363b7ed0e08f0aabe"
    sha256 cellar: :any_skip_relocation, sonoma:        "06b34653e9eaf8c03adf92454539029c03f6cd20dc5795605035549ecc0f01af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb908400abaec723aa8970de1091fe2ed71d98e108f5c0a424510e8b4f252ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3927d7036a08685d9df626fbbd1b19a6845ba8a427d6e2b3421716f8f97c2300"
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