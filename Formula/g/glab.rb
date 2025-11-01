class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.75.0",
    revision: "1b7d73fd0e883f6bf150208661f39f14db3514d8"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "339487454b7192126485d651ca80c54bc121828d53b050334d3f15b000870fa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "339487454b7192126485d651ca80c54bc121828d53b050334d3f15b000870fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "339487454b7192126485d651ca80c54bc121828d53b050334d3f15b000870fa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fae539b3629fca6b3796f89a92285c6651a012b1c0fe221785b247cdf6e569b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f8b0553db1cbd5bba6bc8a1edb5e4e07f365ad3ae46ae817f53c404dfa6c33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcbee889937d6b523ea545ac7bc85570f22cb20ebed107c97c1a54c6508417d9"
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