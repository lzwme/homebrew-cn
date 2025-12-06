class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.79.0",
    revision: "19f580807f390d5725a2c972bd2026b3dd24a50c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f9c352b43577d09a9a4ee9460de6b98a39a5de627bcb0a8b667b1c05947f241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f9c352b43577d09a9a4ee9460de6b98a39a5de627bcb0a8b667b1c05947f241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f9c352b43577d09a9a4ee9460de6b98a39a5de627bcb0a8b667b1c05947f241"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce87e93d4330ec359a520976a47f48695c178abd2cce4372e3ae085508cb6102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "055e3c4ef62e64e41ac848d14b29616d0bd87633cbbded2091c9293bc613e40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf565f2f85dd3781e84a3d6eda2b4c20fc16c5c0cd0e3fa9697ea09221dcaca"
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