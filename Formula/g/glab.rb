class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.73.0",
    revision: "f3a36aa53a1b7679abf00f0b3d14f7858f552022"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "276e140e477913ce7cc57e264cfeb37d81f85f23b63c1bc13f7f1e49e9ded526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "276e140e477913ce7cc57e264cfeb37d81f85f23b63c1bc13f7f1e49e9ded526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "276e140e477913ce7cc57e264cfeb37d81f85f23b63c1bc13f7f1e49e9ded526"
    sha256 cellar: :any_skip_relocation, sonoma:        "feae3071944fe398db9e393cf24a782edf209c265c85184da54b969f511c42d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6063399010451adb31569b24700029a5e92a1ed32517da3ec24c69e9abfe6bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d582afb491433b5529d07510ab103fb4793e00edf0b877fbd489f31d006cc92"
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