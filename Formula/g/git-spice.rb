class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://ghfast.top/https://github.com/abhinav/git-spice/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "120743a19effd928bcaf0e28812d036bfecc1434f91ca332342ea427048b4ce9"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d38fdddb1f8cb3cf5db25301cbd6bab8e4b7f3bf245cc18e2d98215ac7174bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d38fdddb1f8cb3cf5db25301cbd6bab8e4b7f3bf245cc18e2d98215ac7174bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d38fdddb1f8cb3cf5db25301cbd6bab8e4b7f3bf245cc18e2d98215ac7174bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7503694b60fee847d5c9683dcee54b9e482812ba44ce73def20d38c9ecc16c58"
    sha256 cellar: :any_skip_relocation, ventura:       "7503694b60fee847d5c9683dcee54b9e482812ba44ce73def20d38c9ecc16c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "037fdd2636a74bf56ee74635b33e62094c63457b2567a03c80fef5193a2e122d"
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