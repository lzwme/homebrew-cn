class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.43.1.tar.gz"
  sha256 "1ea3f451fb7002c1fb95a7fab21e9ab16591058492628fe264c5878e79ec7c90"
  license "MIT"

  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a5a2c52d9238ff8c0164c336dbcbe6def5afc4ea8a514af9217a92ce9b97931"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4080f143569cca30b4e3c49c1571d0dd70e88f048c84c12877663cb4bc35d6c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe4173fae83d89185481cd2c1e58da9498feae9d347d6538acbb97871505e3d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "64b72adadef26518516512b5cc0b7ab39a1bf01b6a0a5a30bbbf5afbb556dea1"
    sha256 cellar: :any_skip_relocation, ventura:        "048ea9fa7aecd2fcae9930e8630d4e0db82570f5d9eb3aeb7f3879b3a01db10b"
    sha256 cellar: :any_skip_relocation, monterey:       "3f8b6bdccb125ae6d287eacd7b13c6f71da64e539251eed88fe968932125d5a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca7f124a273cae2e820a4ef58f7c26e60c684f52fb239aafff88a0a8868e7734"
  end

  depends_on "go" => :build

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