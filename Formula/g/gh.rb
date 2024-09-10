class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.56.0.tar.gz"
  sha256 "ed19f01df36e336472c434edfadf01a2cbe4bf07394724b064a80c8fd6a0dc1e"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88dccfa41d529d4a8659264e099e055234864df77487b210ac0095aff135e0b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88dccfa41d529d4a8659264e099e055234864df77487b210ac0095aff135e0b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88dccfa41d529d4a8659264e099e055234864df77487b210ac0095aff135e0b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "595b0a901c733b090bf07a64f4f86ca123c60e3209fea8165cbadd78124c5333"
    sha256 cellar: :any_skip_relocation, ventura:        "8c4004ef3b9a35f53cdc16a4f61b5edfb24dce381cb26e9ccdda38707c44486e"
    sha256 cellar: :any_skip_relocation, monterey:       "c935aaf476aa48ca59b439d9dede57a39c1c4b9179cca38d30541228885c78b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efcb50df5e76b312438082c70cbe34e1660067492d2c53e1a2fe9269c21747d8"
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