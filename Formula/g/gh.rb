class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.47.0.tar.gz"
  sha256 "f87622443f143a84462a026534cf234b059c609a6053d7c9ff692c45b30e63f4"
  license "MIT"

  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d3b6ad6d60935356e465775e9c4b1cd865275f64abfff231c6c36bb152eed88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1edfed6e448469fc207b24dbe3a8afff53cbe9d13b87287dd9a86913f80069d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcf0039d3289d7ca75d441ad3c7ac9875e0d03245c5d813d5ed3833fca235d5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5e9c243938787b1d63535fe6d8b44eefbefda6783c316269fd742ab84fabc98"
    sha256 cellar: :any_skip_relocation, ventura:        "a3f70629667a27da10de5c45b61732e970a3502b13a502df72ee448db5a13eb8"
    sha256 cellar: :any_skip_relocation, monterey:       "ddec14e6710597ec70a38d10d3163a78602b63c6fe1c7e08025424d7a23adb93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e735ee91072c641d57e549568dab7bedb9a5bc6400004dd003781fc202d409ab"
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