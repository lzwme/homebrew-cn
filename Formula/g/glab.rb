class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.65.0",
    revision: "8514bc42ef2c15a0ff27782a22b3add584b0d21c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f6df9be0c29e18926fbf3d990f90c3fd7a1da51eec1a495e487db0a0204ac17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f6df9be0c29e18926fbf3d990f90c3fd7a1da51eec1a495e487db0a0204ac17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f6df9be0c29e18926fbf3d990f90c3fd7a1da51eec1a495e487db0a0204ac17"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f4800cc1cd64f84b50f37d11164d712199d984dea780fb2605f7be862f0e7f9"
    sha256 cellar: :any_skip_relocation, ventura:       "8f4800cc1cd64f84b50f37d11164d712199d984dea780fb2605f7be862f0e7f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9537e826142d09e599e16a960632a195cfa2748924242f27be0e26ab3d857b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3669bce95271e63c3009016d8a256ae7f9c6a366df6ccbfe00c6f085c484bd"
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