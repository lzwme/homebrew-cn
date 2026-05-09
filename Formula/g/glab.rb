class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.95.0",
    revision: "6a2f207dd73796fb27873b9197bebbaf63e6fae2"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aedfb83cd0acfacfa76faf0c6995cc30108b33e587cfd8c5fccc8c68ad74207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aedfb83cd0acfacfa76faf0c6995cc30108b33e587cfd8c5fccc8c68ad74207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aedfb83cd0acfacfa76faf0c6995cc30108b33e587cfd8c5fccc8c68ad74207"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7eed2d17957aa72736039054af1e3b3b0816785533b5782013bd1bd42810181"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf9f3451e6fd6e3b2c4894676845ef2ad7e35f49d62a28a753943c551cac751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f707c2a34e93f613e40f07c3321db5a09ad3e619ab54139585382e8de82d664"
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