class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.50.0.tar.gz"
  sha256 "683d0dee90e1d24a6673d13680e0d41963ddc6dd88580ab5119acec790d1b4d7"
  license "MIT"

  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f626c906d08ee109544d8adfc421d3ca8ff064d272cadfba4137766d2ce6712"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5112f8a465b693e5395f6ad6b7547cecf60fd54c6b64b78cc55ae4ce1c5cff65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11549730f591c51781bdd0fc1d8e9e481c30da0be608baaf943766ea7b50832d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba15edc1f7bb74872368d9acb9f5a087731607a5c6d98202dcf4a0d7ea5e7ca2"
    sha256 cellar: :any_skip_relocation, ventura:        "4db835f7416406e4db854f71396260f9969897dc9d164ac8d3efbad21b93f825"
    sha256 cellar: :any_skip_relocation, monterey:       "3aa8c19d4f916a1785cb0cd04c2e21904aad44741243852c50f3a5f9ef502e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eda8382e86913546175a51b4434911e0e26cbeb75f8dcac88fdf7e60e295728"
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