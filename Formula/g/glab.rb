class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.63.0",
    revision: "1db67b8fabc4a2cd5227579f0ab234c0475feed6"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42153ba44c7a2783ef1aece0bc8befef78357d3eb66e1405129e3f4a5026cdf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42153ba44c7a2783ef1aece0bc8befef78357d3eb66e1405129e3f4a5026cdf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42153ba44c7a2783ef1aece0bc8befef78357d3eb66e1405129e3f4a5026cdf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "097d392257705a609c40643807b51c2644b332a998068e9d19c12069b59e9cf0"
    sha256 cellar: :any_skip_relocation, ventura:       "097d392257705a609c40643807b51c2644b332a998068e9d19c12069b59e9cf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d4ed63002682fa183c812a264f15555e29ac887422f294f4f7bcd79d7b29090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdfed63c708aaec5c3c9b9c59c88f18eee617f71e61766350445c57949139834"
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