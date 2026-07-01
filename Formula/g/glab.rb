class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.106.0",
    revision: "fc1869c7555df65250a17781e24ab077ad1db267"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8781238dcebc3438cad9ad40eb145c480d1e2f681260a9ca21d8a6f4857a3783"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8781238dcebc3438cad9ad40eb145c480d1e2f681260a9ca21d8a6f4857a3783"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8781238dcebc3438cad9ad40eb145c480d1e2f681260a9ca21d8a6f4857a3783"
    sha256 cellar: :any_skip_relocation, sonoma:        "6acbf821136ca8de697edd57ca7a086d78eb16717a1c4eebb001050a2d434248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5114ddd6229368d748003c43d9caa42e47c976a358d05f56c1e3c9ee4884aa29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ef631c07dea5ad8069a3c1b5983a89d0785eec6c80d6833dc4a29bd4e85bdc"
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