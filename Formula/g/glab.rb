class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.85.2",
    revision: "dfbbbe3b76ae0eb12a8604906eb859a5d7d54427"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aaab051b4327b8fbe28b715973653ac742698e3099a0ea7f773860f43173f46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aaab051b4327b8fbe28b715973653ac742698e3099a0ea7f773860f43173f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aaab051b4327b8fbe28b715973653ac742698e3099a0ea7f773860f43173f46"
    sha256 cellar: :any_skip_relocation, sonoma:        "a62d2aad3405766f50460f7eec35e08b7cc494e912ed79c4b28a7d2f8fdbe38d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d65353e0ee6a6e59fd55e8ea05d24142f3c240b6c3ac06871c6262f272ecad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b87ff95ea065cba7dff722497818df343798313d4452b3d74e921c385743d7"
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