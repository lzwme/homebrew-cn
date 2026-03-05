class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.88.0",
    revision: "a1f268d788c25c7e4cb48cb914ee5c056f71b92b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69e3384329bfcfe958e438688b9a9cb097b87ff291c10b4102f1e01cd1ba99d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69e3384329bfcfe958e438688b9a9cb097b87ff291c10b4102f1e01cd1ba99d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69e3384329bfcfe958e438688b9a9cb097b87ff291c10b4102f1e01cd1ba99d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5085e7a23514577b162866cf97787218fc5f0a9cf32a8e9f8b665822043ae8b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdda19212bcd4e6e05d90b8f7d937422a353144de91ffa11af8c038c2f031383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2c53b1aecdbc71b8c5e7021631339602c0238486bfbecd9596fe3dec18eb009"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end