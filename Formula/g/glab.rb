class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.110.0",
    revision: "1797d21541f52533a001b7330ae1161b4a5ddfd3"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc9ddc2a0459a8451757de9808d837171cadff473e5e4d7843887b789c2087ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc9ddc2a0459a8451757de9808d837171cadff473e5e4d7843887b789c2087ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc9ddc2a0459a8451757de9808d837171cadff473e5e4d7843887b789c2087ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b24d53e5f249197e7ab22c79cebf2783319ab4b73fdab364436f525a4f7543b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3035def12e30bb55510077af9e362ef42d0af811bd8caab6f9edda20273a3a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cfa7153b828b6b467bf31214f4627ec32431a7617930f90e9536c857fb25d3f"
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