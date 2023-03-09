class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://ghproxy.com/https://github.com/cli/cli/archive/v2.24.0.tar.gz"
  sha256 "651e873f6a4aafec0c413f18074b70f5d6a1f394a785073a978353918dce2f4f"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e1e72192094cb03658bd899e05aa0dd324f65c74280e69ccba10a09637bcf07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e1e72192094cb03658bd899e05aa0dd324f65c74280e69ccba10a09637bcf07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e1e72192094cb03658bd899e05aa0dd324f65c74280e69ccba10a09637bcf07"
    sha256 cellar: :any_skip_relocation, ventura:        "2bd950c5185fd36c29e4b3f11e09ef520b27dcca4b4314c0d3f6e892f1c93f53"
    sha256 cellar: :any_skip_relocation, monterey:       "2bd950c5185fd36c29e4b3f11e09ef520b27dcca4b4314c0d3f6e892f1c93f53"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bd950c5185fd36c29e4b3f11e09ef520b27dcca4b4314c0d3f6e892f1c93f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eadfc9899361e25c0d17a0db14f20e30fb58da545e40e17a796a0c3bd488f56"
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