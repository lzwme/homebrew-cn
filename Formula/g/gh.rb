class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.96.0.tar.gz"
  sha256 "8d80d0aeccea7bec8024f8c30365bbfa76852901f2b2cb0afb7ab2cbf6d317c2"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7abef44486b0c535f6fe84b4173e61bdfb9320203da51e2fa0a982ac537a1e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a42e9e65d263813f863054a1d2ae787a26e02257584a04e88c93de9c68731add"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48caebec1ed6433ffd802a2473f896db726afdf07e3f9ee88779a56a77c9fc48"
    sha256 cellar: :any_skip_relocation, sonoma:        "43d7cb512c30ba3066587fc6dd52836a3a5dbd8c50b134a98bfcadda9efe7008"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2d40284e4e6ab847da085b27621baa5f9152fc00022bdc25103d4e35884caf5"
    sha256 cellar: :any,                 x86_64_linux:  "7a25cdb2d10f2ba63c4e1a9c264c065f4a1ce4d9427985fa20ee68295aecc87b"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    ldflags = %w[-s -w]
    ENV.prepend_path "PATH", buildpath/"bin"

    with_env(
      "GH_VERSION"   => gh_version,
      "GOBIN"        => buildpath/"bin",
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "licenses"
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install buildpath.glob("share/man/man1/gh*.1")
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
    assert_match "GitHub CLI third-party dependencies", shell_output("#{bin}/gh licenses")
  end
end