class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.53.0.tar.gz"
  sha256 "5e47d567216b1f63a4939e634f9067c9b60b0852625edf8ad10e1b9be5033cff"
  license "MIT"

  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "116cde6a545afc01287eebf17c929017dc32356fe5d3f9ad4d7d68c7fea17941"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43ca741a398e63d51e8331ac3c54e41af78c011fb09e10397a8a1bce872063aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e7c3b771bad9f96575caea495065672cc1dcf0b80b2e744902c678a4c81f3d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3c6a77e05d868feedbc328f13c6d22a10f1cdc457b6a1c37494b8140897e26b"
    sha256 cellar: :any_skip_relocation, ventura:        "f9b40bc12182613072b69f352bcdb76f33a43afa691e66dcc8eb59950713f0df"
    sha256 cellar: :any_skip_relocation, monterey:       "8381dad10daf719a2e298232e676d5e383bdeebed43ebe1e6e5348d60ac98275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2f6883ead7cfcabb65a3891876c7d8eba6e99dcae35e4f0a5738be3c911c34f"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=clicli",
    ) do
      system "make", "bingh", "manpages"
    end
    bin.install "bingh"
    man1.install Dir["sharemanman1gh*.1"]
    generate_completions_from_executable(bin"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}gh pr 2>&1")
  end
end