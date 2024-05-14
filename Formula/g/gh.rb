class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.49.2.tar.gz"
  sha256 "e839ea302ad99b70ce3efcb903f938ecbbb919798e49bc2f2034ad506ae0b0f5"
  license "MIT"

  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9b943de9c581a597c47e23c5037bb7b609079e835b1553c5a653abf439254f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62c75b60d2b9a095af188a2c083d3dd490f9ff916d79d2d4a80c65f01911f6e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f21c4aaf83538ba151fcd67550fa166d8c9bf9174be9bc2cb7c262aa20225fd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "850b783a744e4f46052f1bf6bdd0350ce2bb364a2116c6a1149345d66f27d0a6"
    sha256 cellar: :any_skip_relocation, ventura:        "ab0f14465d87e4021dc17ee7dbc19aa2cb90c406dc1547b2fae13d2f42c21390"
    sha256 cellar: :any_skip_relocation, monterey:       "761f87346c812176b6336161d367b9ad29edd4b33ad646ca6333897f8c9115f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93dbfb4394fbac6bf690ea05611983b66cc145622ee29d03a178ae76fdb0e38"
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