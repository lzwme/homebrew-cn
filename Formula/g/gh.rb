class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.67.0.tar.gz"
  sha256 "8f685207c63cebfde375a20b235e34012d75d4d41fbaad8b2cc1b8cfc1eceae8"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "579787d70807effe3e75e8ba8b2975e621260a10a05dd229cf42ac022d8a6c9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "579787d70807effe3e75e8ba8b2975e621260a10a05dd229cf42ac022d8a6c9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "579787d70807effe3e75e8ba8b2975e621260a10a05dd229cf42ac022d8a6c9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d665e87ebc2ac4a46d6f20818fa616d5d9a82248ba4305b5201b34f9ac7cf73d"
    sha256 cellar: :any_skip_relocation, ventura:       "383aa106299399d9b0b5f135bb71bb5db84696968f450235a6c7c0f9dfe32f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "092eb15fbf27b1d47a227b55bfec943ba6ff88b8895e44a41621053e1ea4551f"
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