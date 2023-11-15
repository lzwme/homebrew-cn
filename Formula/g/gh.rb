class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghproxy.com/https://github.com/cli/cli/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "14f4de2d1e8ec465b61315df13274f928364b9d9445675b475faa35c81330b4f"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbfc7b407790ea52a0d3bf7e9550b3a86909c4bb0c56f7feee2b09847e30a096"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12284ed3a1fafdbc183d8ff5be10166cd652158dedd2804bae3b783bb488f7fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91fc4cfbab82dcdf87fbcfc30c937321e546feb1f90a09748a57e2bd877a2221"
    sha256 cellar: :any_skip_relocation, sonoma:         "cea36fc39957b236ce3e37178d8f6250d5d8f82ed14f7a5f1fb0698e1ba0c465"
    sha256 cellar: :any_skip_relocation, ventura:        "19b26fe3fdcf8aa60916a5dc2a7bfec344178d00f32bf6bdcf3fa950bfa521dc"
    sha256 cellar: :any_skip_relocation, monterey:       "2940f2629e2c92d51a03b64e21f49a3ad09e4716be1080980ac8b9b7b858d330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b320b08fb42d8acd5ee9f2ddddaaa29b23e9f68898be6b8f0ce915673f9fbfcb"
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