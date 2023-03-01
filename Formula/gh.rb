class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://ghproxy.com/https://github.com/cli/cli/archive/v2.23.0.tar.gz"
  sha256 "1e9f92a47caa92efedc06b22cfe9c951c5163c4a9bc60a45d477fd5d9b592e54"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5199d0960a3a5b24d2224706c10db4752a28d5a3ed4670ab16a6892b3066bb51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9e3b41d4c784ec831002c5e64f0f21e86afb6de7aed33164728e7006782be66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b3d4ab42a97160b922d63572f128a1a9f7e8d4bb780b4f50640ad4481281079"
    sha256 cellar: :any_skip_relocation, ventura:        "1e9306dd50c18e00fcb46c12773829166534016fa48835561b1f2f2b587e03bf"
    sha256 cellar: :any_skip_relocation, monterey:       "d46d29dc4c670c314e98fc79f34e5a2eaa64a0e343b5a9dcb6ea5f7f5205ab51"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8816c0b38873b8415961d664e0df465e2c673afebac65ebd7e2c61624b7d36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9bb11ba84ac40cbab211b9639e1c31ffd6b27ec08f5a09b09a7e27f69d39ca8"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end