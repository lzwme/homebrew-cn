class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.113.0",
    revision: "d62881304ccba9e24d07bcfb2c5e8bcae3f17f75"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21a2b11eb5fdb3620b3810325085b41ebd1f4421c49695c3a6cd98ee8def8f1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21a2b11eb5fdb3620b3810325085b41ebd1f4421c49695c3a6cd98ee8def8f1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21a2b11eb5fdb3620b3810325085b41ebd1f4421c49695c3a6cd98ee8def8f1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd70ac028b9e41c84e570262be53ca449ae4180d0d842f093780595f7013b91d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d925c61d98a8ef2976588cf4aa6a8725c0de8e6d7d1150418373852dc193db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13b6a6d05d9278518c899642a82239845acedf64aad80e78bd03a1edd7893a16"
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