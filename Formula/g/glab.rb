class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.85.1",
    revision: "cbc454067c503122c86615e24b629dc0ee275f28"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd046aba4d36644b60a50b9530e9747d8eda32e1447b30181da68c25bcafc63f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd046aba4d36644b60a50b9530e9747d8eda32e1447b30181da68c25bcafc63f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd046aba4d36644b60a50b9530e9747d8eda32e1447b30181da68c25bcafc63f"
    sha256 cellar: :any_skip_relocation, sonoma:        "42c224bce3159de43662b54613ae30cde7a60bc4007dcb0cdffa726fd32bdeb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71deb235c1499431a1ae42dba32653b7dceadf3102606dc276dd7af444cc65f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b37271c6e47a0649b0ae1f782bba17de5583445a2d0d80bfca6a4c069ff98bc8"
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