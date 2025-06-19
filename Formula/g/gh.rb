class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.74.2.tar.gz"
  sha256 "58d383e75e1a6f3eb5e5694f232d1ed6f7f53681fda9c6a997e6e1be344edd94"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8d12facc23d7e2efdb21bc4eaa55058d8385609d1c8734685f406996074ff12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8d12facc23d7e2efdb21bc4eaa55058d8385609d1c8734685f406996074ff12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8d12facc23d7e2efdb21bc4eaa55058d8385609d1c8734685f406996074ff12"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3f8a873387da7e9087c2ce2e38ddcf9bdd8e5365033db59c10517972c741062"
    sha256 cellar: :any_skip_relocation, ventura:       "53d91576a846085b553ec452e38ebbca52202fa5957b5576140fdc8aa42965e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3e209130aadf0f998201e5b588498b6f538488bf55eadd4672822a7ab4a8161"
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