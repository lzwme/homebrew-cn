class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.44.0.tar.gz"
  sha256 "babaa83c9662d0bb1b500f76b878b11a0b83342ced30ac5232cf811762310ffa"
  license "MIT"

  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b6b299250d32b2cab842f2e70114b7057b614632ccef7ace1e5b5e0b365e340"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d077bbe8056b69c895680aee1ac234aabd073d8043da9af3cad1fa6f4ae3d702"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad593578df3865242f2e714fe4daeaf1aec3c53e0bf7cf3b9ec3a407a946f3a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "02962da20e8869ee18c76361b8bd68e68df869bea0bbed35fa50bd8ea38852ec"
    sha256 cellar: :any_skip_relocation, ventura:        "f7617c474d78ab13d9944d44cc0a6f248404214ec0c519557bbd56ff7be52b53"
    sha256 cellar: :any_skip_relocation, monterey:       "e9891b9f8cfa50df418138210f8e41d674d6f1a0a2d062529e39aab5f2e1f1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49b9ee55757388acf5f2776eca0cdc02dc82750a13fb2763b28281edcb809268"
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