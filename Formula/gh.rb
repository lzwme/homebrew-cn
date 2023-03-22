class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://ghproxy.com/https://github.com/cli/cli/archive/v2.25.1.tar.gz"
  sha256 "d3b28da03f49600697d2e80c2393425bd382e340040c34641bf3569593c7fbe8"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "834c758d62f9f7935527d73ae015ff3c9b6c6926b48fb300a698cfdeddb1398b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "834c758d62f9f7935527d73ae015ff3c9b6c6926b48fb300a698cfdeddb1398b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "834c758d62f9f7935527d73ae015ff3c9b6c6926b48fb300a698cfdeddb1398b"
    sha256 cellar: :any_skip_relocation, ventura:        "3651e49725b6153bd8be96583d0e4aa703db94d97b234614f0ceb26a6ecc535d"
    sha256 cellar: :any_skip_relocation, monterey:       "3651e49725b6153bd8be96583d0e4aa703db94d97b234614f0ceb26a6ecc535d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3651e49725b6153bd8be96583d0e4aa703db94d97b234614f0ceb26a6ecc535d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b91fd4481ebe71a5a2978e856b0c8eb3542e71a2653a4df92e1b2d8f4c62ed"
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