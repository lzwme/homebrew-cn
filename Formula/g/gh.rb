class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.63.2.tar.gz"
  sha256 "2578a8b1f00cb292a8094793515743f2a86e02b8d0b18d6b95959ddbeebd6b8d"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "157549400ee2105eb7415d085e30e2673ef946ec9e40e980b1118248f1613508"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "157549400ee2105eb7415d085e30e2673ef946ec9e40e980b1118248f1613508"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "157549400ee2105eb7415d085e30e2673ef946ec9e40e980b1118248f1613508"
    sha256 cellar: :any_skip_relocation, sonoma:        "f569a7fb14fe1d3ad72eafd02ad8de93510cd36266e9e1cba4a62e1b17456e9b"
    sha256 cellar: :any_skip_relocation, ventura:       "9e500e7c070f4699be1009c236d5e5b4a9c6f952e56d4cda9a70463d97dbba0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e963d102f8996d529c5440a375d6d96a87aedb90b65197ff79ce976a36731b14"
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
      "GH_VERSION" => gh_version,
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