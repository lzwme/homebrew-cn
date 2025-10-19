class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://ghfast.top/https://github.com/abhinav/git-spice/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "3ee62e5c6745c75ca8a606b880e4952e97a217ff0f06ce990479879fabdd19ed"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "299136c8b9a1acb5ccf6bdc6beb3f6fd42c0d8095f914b27c9de99272ef3018f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "299136c8b9a1acb5ccf6bdc6beb3f6fd42c0d8095f914b27c9de99272ef3018f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "299136c8b9a1acb5ccf6bdc6beb3f6fd42c0d8095f914b27c9de99272ef3018f"
    sha256 cellar: :any_skip_relocation, sonoma:        "be3aee859e96dd56257b82070561f66d3ce511e34db1ddf2582df74132f2c59b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "495cac5bca6c81b7b12abf498ad37b137ae49aae557d36fc2262354cbe5da858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cde186a04c65d9f0c5a20bad2c847bd390101c1c53e804b7ab5c0d7ca54ecb7"
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