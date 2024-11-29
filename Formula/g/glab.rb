class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.50.0/cli-v1.50.0.tar.gz"
  sha256 "36512e81c1c88d95a9154357e7bf5f1f167f8e53ea628d7e6836d248a9031b9b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fbbee9d4b451429d45b8d6bfe17a9993a2762679be5cf99b0d51697708ac9ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fbbee9d4b451429d45b8d6bfe17a9993a2762679be5cf99b0d51697708ac9ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fbbee9d4b451429d45b8d6bfe17a9993a2762679be5cf99b0d51697708ac9ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "9158de63dd9a6c4a3b03b359aa46822fb84607bab4e46108a4da0679c274b54d"
    sha256 cellar: :any_skip_relocation, ventura:       "9158de63dd9a6c4a3b03b359aa46822fb84607bab4e46108a4da0679c274b54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5c6a3c3745197c42494371bc4f98a27a88b96b64090e0897fe1c42401dbd538"
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