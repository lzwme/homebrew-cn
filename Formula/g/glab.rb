class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.111.0",
    revision: "2389345977f28e13744e22b5802d2bbb5887cb7f"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24342dc29f57aaec7bdf916e2f83ddf35366dd99862895efd6217c8afd2dbcbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24342dc29f57aaec7bdf916e2f83ddf35366dd99862895efd6217c8afd2dbcbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24342dc29f57aaec7bdf916e2f83ddf35366dd99862895efd6217c8afd2dbcbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e29420556c3c0f57485ef2ae960fc121d4ddb41636359c2faccbf46fd598dd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "008c8b6237602e27e96566ccc0c1a4f32cd03ace23a9526ba0dc40b575517683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910ccee07808e612d5217ff51d0058dca8ec8f0073adaf4129475f411f7f176e"
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