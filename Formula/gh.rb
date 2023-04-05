class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://ghproxy.com/https://github.com/cli/cli/archive/v2.26.1.tar.gz"
  sha256 "3552c0be9b24cf1b04b19f3cddc30f067a9761bd8872b591e02bf3147de5dd0e"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cdc8b94f02410c2317d1b73af2254926740cdedfe7655822275093130bfbebb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cdc8b94f02410c2317d1b73af2254926740cdedfe7655822275093130bfbebb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cdc8b94f02410c2317d1b73af2254926740cdedfe7655822275093130bfbebb"
    sha256 cellar: :any_skip_relocation, ventura:        "92866644af1a855c07cf6d2a042f8e57b1e0faa991c67bef3dfffe82305b0b4f"
    sha256 cellar: :any_skip_relocation, monterey:       "92866644af1a855c07cf6d2a042f8e57b1e0faa991c67bef3dfffe82305b0b4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "92866644af1a855c07cf6d2a042f8e57b1e0faa991c67bef3dfffe82305b0b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "488f06c3dd125fa85895878106b9066dbf3233e9c1b26e8cd189ab05cd50c4c5"
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