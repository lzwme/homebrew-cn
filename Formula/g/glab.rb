class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.121.0",
    revision: "4d447cc6c19858928884626d802c8f7b7c5f799e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ce99b7e0fe822119ca77aa06009c4ca3b75098ea9cee89d1e45f978124476ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ce99b7e0fe822119ca77aa06009c4ca3b75098ea9cee89d1e45f978124476ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ce99b7e0fe822119ca77aa06009c4ca3b75098ea9cee89d1e45f978124476ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "26712904038b5c637d02c33b2eca9b73c07a33ef9c1d5cc1e19f4c906cbea601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "49aea8d72711425d622676ccf2cd56c54bd9cab1c4fd57fdef4e2ff32a5c2b73"
  end

  depends_on "go" => :build

  # `test do` block queries the GitLab API
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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