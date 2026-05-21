class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.99.0",
    revision: "a9ab75a4c2ecd10570ea50d5ee35dfe09dfa5a59"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46622a9d51ea7ca2e8e9572bef4007d8b13bd34647674df6ee1089c005de5316"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46622a9d51ea7ca2e8e9572bef4007d8b13bd34647674df6ee1089c005de5316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46622a9d51ea7ca2e8e9572bef4007d8b13bd34647674df6ee1089c005de5316"
    sha256 cellar: :any_skip_relocation, sonoma:        "836ad0fb63ab450dc7bdf014e738a896e5fd80250295be4b26d3bac28267aa08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0a1403c3e75a3b285e657c1e4c365de1b65249b0bab67d747015314d96a749a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef334ca9ce5846874983a93f47dc93fff354f871d072f02c4f15545313881a60"
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