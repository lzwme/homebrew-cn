class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.42.0.tar.gz"
  sha256 "c25cddb83037f351468eb06ed1ac9cea0a25c8fdf4dcaf9b6eb509c10cedb395"
  license "MIT"

  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4959a42c8447fb5d451c9b43e6f51ce4e276e1347a5679cb4f93601f01accef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07f1db340f5e3da2382ca5db343001b854226802d725058b809e016cc0cd6336"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8066eba3664e2ba697483f0aebe17ba4f2346f4f94c7f8ea245b267238242674"
    sha256 cellar: :any_skip_relocation, sonoma:         "b401bdc47f6147fbf80593182c597a2874ac1f3e8d510a3aa7bcd8895e3d211a"
    sha256 cellar: :any_skip_relocation, ventura:        "6d14826492d9717dc372137019019ec9d98d882cbfce6371ea20d09cbd2f08c4"
    sha256 cellar: :any_skip_relocation, monterey:       "2700af71fe1caab93a884b3a3bc848a4e9327e1c60b01d9c91e4992ac3a391d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7648b7b543e583ea009452a8359e891b95ae2991d058a833039ec7a37a0b14b2"
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