class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.97.0.tar.gz"
  sha256 "18cd1280f70911c9c16dd5965cdac0b9e6b16e54466f0c892ce2829ecdd339a6"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ec14aa54619911082c15a33d60d26ac22de8ae11897e33fdec109c0fdb8ea95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4664cf0a46374aa5623cc1a1f1c0d93e06dca4fcac330523e2218ab8508223a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "273c54556841746036a42825a64195573f409b2250923ff361e5600e8b3d6ffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "28d1e46721edfadd80a9a22e59e6efb225673447564a08646b91feea62cbb0d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4465c0a1b4f4ec9413bcd0d8bf1082c93201cc3098971f35322e632a98513ce6"
    sha256 cellar: :any,                 x86_64_linux:  "9cc3b4f5b727f84738fbce66e4c0bd6cfecdb14a45ce3df3d7f16817f19176d9"
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