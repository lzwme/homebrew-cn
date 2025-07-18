class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.76.0.tar.gz"
  sha256 "101acc7ca272bf3b0e2e5fb39afe7a980afae53656f1d09d5630a57473d9f7db"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeac417f664cd46ebaefac910401f744be625a1e9c1f847199dd7606cf636ae3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeac417f664cd46ebaefac910401f744be625a1e9c1f847199dd7606cf636ae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aeac417f664cd46ebaefac910401f744be625a1e9c1f847199dd7606cf636ae3"
    sha256 cellar: :any_skip_relocation, sonoma:        "210302e13bd7f20fc7dc6c119c75970b4cc7689a2da417cfac1c15789ab0bac8"
    sha256 cellar: :any_skip_relocation, ventura:       "222742208c609224ee831e6e40c6c842d74043403622a5b3b2e7b7240f99e269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f149ea346b7d5dc68a1db1b34512f0cb856b8306580151a70dbfea797ecde31d"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => "-s -w",
      "GO_BUILDTAGS" => "updateable",
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