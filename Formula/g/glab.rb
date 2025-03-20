class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.54.0/cli-v1.54.0.tar.gz"
  sha256 "99f5dd785041ad26c8463ae8630e98a657aa542a2bb02333d50243dd5cfdf9cb"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9d5977a27f13e829ab983cb21075687b1389f7a8f8a1546ca2cebe46404d1d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9d5977a27f13e829ab983cb21075687b1389f7a8f8a1546ca2cebe46404d1d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9d5977a27f13e829ab983cb21075687b1389f7a8f8a1546ca2cebe46404d1d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5f61a7f4ed231bfeefa90c94acac216f16e769f43ac3a2bc4de5d784017775b"
    sha256 cellar: :any_skip_relocation, ventura:       "a5f61a7f4ed231bfeefa90c94acac216f16e769f43ac3a2bc4de5d784017775b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "486911139b20c2e9ffdc4ebcfd2c828783f818b3a954bbd05abd5cb1a6e7dff7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
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