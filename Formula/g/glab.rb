class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.66.0",
    revision: "8df370252ab38a0c7d426bf9804871ea348bf946"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2100f66df5c857f2785f7779d0d21453c1e6e299816d0d27e910f216f93c221a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2100f66df5c857f2785f7779d0d21453c1e6e299816d0d27e910f216f93c221a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2100f66df5c857f2785f7779d0d21453c1e6e299816d0d27e910f216f93c221a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d3e2d0ee803ff3a8b135f9546cf6f24f1807afff8770b8d1f5c4f43722c45f3"
    sha256 cellar: :any_skip_relocation, ventura:       "4d3e2d0ee803ff3a8b135f9546cf6f24f1807afff8770b8d1f5c4f43722c45f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae7747bf66bd0b2cb7663da0319baa0b19cf5fa5a282aab5b54f65d82d13ab6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a56b6ed42a0b1a836f3d4ffccbda6595dee967a282c1a4a4ae81e89f4b51192"
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